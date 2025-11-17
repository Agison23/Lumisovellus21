'use client';
import { useTranslations } from 'next-intl';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import Link from 'next/link';
import { useMutation } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { toast } from 'sonner';
import { FormEvent } from 'react';
import { registerAction } from '../actions';

export default function RegisterPage() {
  const t = useTranslations('RegisterPage');
  const router = useRouter();

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

    // validate that the password is at least 8 characters long, has at least one number and one special character
    const passwordRegex =
      /^(?=.*[0-9])(?=.*[^\w\s])[A-Za-z0-9!@#$%^&*\-_+=~`|\\:;"'<>,.?/]{8,}$/;
    if (!passwordRegex.test(password)) {
      console.log(password.length);
      throw new Error(t('errors.passwordTooWeak'));
    }

    if (password !== confirmPassword) {
      throw new Error(t('errors.passwordsMismatch'));
    }

    await registerAction(email, password);
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
            className="text-white"
            type="password"
            name="password"
            required={true}
          />
        </section>
        <section className="flex flex-col gap-1 text-muted-foreground">
          <label htmlFor={t('confirmPassword')}>{t('confirmPassword')}</label>
          <Input
            className="text-white"
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
