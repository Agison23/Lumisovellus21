'use client';
import { useTranslations } from 'next-intl';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import Link from 'next/link';
import { useMutation } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { toast } from 'sonner';
import { FormEvent, useState } from 'react';
import { registerAction } from '../actions';

const PASSWORD_REGEX =
  /^(?=.*[0-9])(?=.*[^\w\s])[A-Za-z0-9!@#$%^&*\-_+=~`|\\:;"'<>,.?/]{8,}$/;

function validatePassword(password: string) {
  return {
    minLength: password.length >= 8,
    hasNumber: /[0-9]/.test(password),
    hasSpecialChar: /[^\w\s]/.test(password),
  };
}

function isPasswordValid(password: string) {
  const validation = validatePassword(password);
  return (
    validation.minLength && validation.hasNumber && validation.hasSpecialChar
  );
}

export default function RegisterPage() {
  const t = useTranslations('RegisterPage');
  const router = useRouter();
  const [password, setPassword] = useState('');
  const validation = validatePassword(password);

  const handleRegister = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.target as HTMLFormElement);
    const firstName = formData.get('firstName') as string;
    const lastName = formData.get('lastName') as string;
    const email = formData.get('email') as string;
    const password = formData.get('password') as string;
    const confirmPassword = formData.get('confirmPassword') as string;
    if (!email || !password || !firstName || !lastName || !confirmPassword) {
      throw new Error(t('errors.missingFields'));
    }

    if (!isPasswordValid(password)) {
      throw new Error(t('errors.passwordTooWeak'));
    }

    if (password !== confirmPassword) {
      throw new Error(t('errors.passwordsMismatch'));
    }

    await registerAction(firstName, lastName, email, password);
    return true;
  };

  const formMutation = useMutation({
    mutationFn: handleRegister,
    onSuccess: () => {
      // we need to revalidate the path to update the auth state
      router.refresh();
      // then redirect to the weather page
      router.push('/');
    },
    onError: (error) => {
      toast.error(
        error instanceof Error ? error.message : t('errors.registrationFailed')
      );
    },
  });

  return (
    <div className="w-full h-full flex flex-col items-center justify-center gap-4">
      <form
        className="flex flex-col p-2 gap-4 rounded-md border border-accent max-w-md"
        onSubmit={formMutation.mutate}
      >
        <p>{t('title')}</p>
        <section className="flex gap-2 text-muted-foreground">
          <div className="flex flex-col gap-1">
            <label htmlFor={t('firstName')}>{t('firstName')}</label>
            <Input
              className="text-primary"
              type="text"
              name="firstName"
              required={true}
            />
          </div>
          <div className="flex flex-col gap-1">
            <label htmlFor={t('lastName')}>{t('lastName')}</label>
            <Input
              className="text-primary"
              type="text"
              name="lastName"
              required={true}
            />
          </div>
        </section>
        <section className="flex flex-col gap-1 text-muted-foreground">
          <label htmlFor={t('email')}>{t('email')}</label>
          <Input
            className="text-primary"
            type="email"
            name="email"
            required={true}
          />
        </section>
        <section className="flex flex-col gap-1 text-muted-foreground">
          <label htmlFor={t('password')}>{t('password')}</label>
          <Input
            className="text-primary"
            type="password"
            name="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required={true}
          />
          <div className="text-xs mt-2 space-y-1">
            <p className="font-semibold">{t('passwordRequirements.title')}:</p>
            <div
              className={`flex items-center gap-2 ${validation.minLength ? 'text-green-500' : 'text-red-500'}`}
            >
              <span>{validation.minLength ? '✓' : '✗'}</span>
              <span>{t('passwordRequirements.minLength')}</span>
            </div>
            <div
              className={`flex items-center gap-2 ${validation.hasNumber ? 'text-green-500' : 'text-red-500'}`}
            >
              <span>{validation.hasNumber ? '✓' : '✗'}</span>
              <span>{t('passwordRequirements.hasNumber')}</span>
            </div>
            <div
              className={`flex items-center gap-2 ${validation.hasSpecialChar ? 'text-green-500' : 'text-red-500'}`}
            >
              <span>{validation.hasSpecialChar ? '✓' : '✗'}</span>
              <span>{t('passwordRequirements.hasSpecialChar')}</span>
            </div>
          </div>
        </section>
        <section className="flex flex-col gap-1 text-muted-foreground">
          <label htmlFor={t('confirmPassword')}>{t('confirmPassword')}</label>
          <Input
            className="text-primary"
            type="password"
            name="confirmPassword"
            required={true}
          />
        </section>
        <Button type="submit">
          {formMutation.isPending
            ? t('buttons.registering')
            : t('buttons.register')}
        </Button>
      </form>
      <Link href="/login">
        <span className="text-muted-foreground hover:text-primary transition-colors duration-150">
          {t('links.login')}
        </span>
      </Link>
    </div>
  );
}
