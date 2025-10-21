import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";
import jwt, { SignOptions } from "jsonwebtoken";
import { JWTPayload } from "../../middleware/auth";

const prisma = new PrismaClient();

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterData {
  firstName: string;
  lastName?: string;
  email: string;
  password: string;
  role?: "NORMAL" | "PREMIUM" | "ADMIN" | "RESCUE";
}

export interface AuthResponse {
  user: {
    id: string;
    firstName: string;
    lastName: string | null;
    email: string | null;
    role: "NORMAL" | "PREMIUM" | "ADMIN" | "RESCUE";
  };
  accessToken: string;
  refreshToken: string;
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

export class AuthService {
  private static readonly SALT_ROUNDS = parseInt(
    process.env.BCRYPT_ROUNDS || "12",
  );
  private static readonly JWT_SECRET = process.env.JWT_SECRET;
  private static readonly JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || "7d";
  private static readonly JWT_REFRESH_EXPIRES_IN =
    process.env.JWT_REFRESH_EXPIRES_IN || "30d";

  static async register(data: RegisterData): Promise<AuthResponse> {
    if (!this.JWT_SECRET) {
      throw new Error("JWT_SECRET not configured");
    }

    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email: data.email },
    });

    if (existingUser) {
      throw new Error("User with this email already exists");
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(data.password, this.SALT_ROUNDS);

    // Create user
    const user = await prisma.user.create({
      data: {
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        password: hashedPassword,
        role: data.role || "NORMAL",
      },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        role: true,
      },
    });

    // Generate tokens
    const tokens = this.generateTokens(user);

    return {
      user,
      ...tokens,
    };
  }

  static async login(credentials: LoginCredentials): Promise<AuthResponse> {
    if (!this.JWT_SECRET) {
      throw new Error("JWT_SECRET not configured");
    }

    // Find user by email
    const user = await prisma.user.findUnique({
      where: { email: credentials.email },
    });

    if (!user) {
      throw new Error("Invalid email or password");
    }

    if (!user.password) {
      throw new Error("User account not properly configured");
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(
      credentials.password,
      user.password,
    );
    if (!isValidPassword) {
      throw new Error("Invalid email or password");
    }

    // Generate tokens
    const tokens = this.generateTokens(user);

    return {
      user: {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        role: user.role,
      },
      ...tokens,
    };
  }

  static async refreshToken(refreshToken: string): Promise<TokenPair> {
    if (!this.JWT_SECRET) {
      throw new Error("JWT_SECRET not configured");
    }

    try {
      const decoded = jwt.verify(refreshToken, this.JWT_SECRET) as JWTPayload;

      // Verify user still exists
      const user = await prisma.user.findUnique({
        where: { id: decoded.userId },
        select: {
          id: true,
          firstName: true,
          lastName: true,
          email: true,
          role: true,
        },
      });

      if (!user) {
        throw new Error("User not found");
      }

      return this.generateTokens(user);
    } catch (error) {
      throw new Error("Invalid refresh token");
    }
  }

  static async logout(userId: string): Promise<void> {
    // In a more sophisticated implementation, you might want to:
    // 1. Store refresh tokens in database and invalidate them
    // 2. Implement token blacklisting
    // For now, we'll just return success
    // The client should remove the tokens from storage
  }

  static async changePassword(
    userId: string,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user || !user.password) {
      throw new Error("User not found");
    }

    // Verify current password
    const isValidPassword = await bcrypt.compare(
      currentPassword,
      user.password,
    );
    if (!isValidPassword) {
      throw new Error("Current password is incorrect");
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, this.SALT_ROUNDS);

    // Update password
    await prisma.user.update({
      where: { id: userId },
      data: { password: hashedPassword },
    });
  }

  static async resetPassword(email: string): Promise<void> {
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      // Don't reveal if email exists or not for security
      return;
    }

    // In a real implementation, you would:
    // 1. Generate a secure reset token
    // 2. Store it in database with expiration
    // 3. Send email with reset link
    // For now, we'll just return success
  }

  static async verifyResetToken(
    token: string,
    newPassword: string,
  ): Promise<void> {
    // In a real implementation, you would:
    // 1. Verify the reset token
    // 2. Check expiration
    // 3. Update password
    // 4. Invalidate the token
    throw new Error("Password reset not implemented");
  }

  private static generateTokens(user: {
    id: string;
    email: string | null;
    role: string;
  }): TokenPair {
    if (!this.JWT_SECRET) {
      throw new Error("JWT_SECRET not configured");
    }

    const payload: JWTPayload = {
      userId: user.id,
      email: user.email || "",
      role: user.role,
    };

    const accessToken = jwt.sign(payload, this.JWT_SECRET as string, {
      expiresIn: "7d",
    });
    const refreshToken = jwt.sign(payload, this.JWT_SECRET as string, {
      expiresIn: "30d",
    });

    return {
      accessToken,
      refreshToken,
    };
  }

  static async getUserById(userId: string) {
    return await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        role: true,
        devId: true,
        ipAddress: true,
        phoneNumber: true,
        lowBattery: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  static async updateUserProfile(
    userId: string,
    data: Partial<{
      firstName: string;
      lastName: string;
      email: string;
      phoneNumber: string;
    }>,
  ) {
    return await prisma.user.update({
      where: { id: userId },
      data,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        role: true,
        phoneNumber: true,
        updatedAt: true,
      },
    });
  }
}
