"use client";

import React from "react";

type Props = {
  children: React.ReactNode;
};

type State = {
  hasError: boolean;
  error?: Error | null;
};

export default class ErrorBoundary extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
    this.reset = this.reset.bind(this);
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    // Log to console or a monitoring service
    // Replace this with your preferred logging (Sentry, LogRocket, etc.)
    // For example: sendErrorToService(error, info)
    // eslint-disable-next-line no-console
    console.error("Unhandled error caught by ErrorBoundary:", error, info);
  }

  reset() {
    this.setState({ hasError: false, error: null });
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-[200px] flex items-start justify-center p-6">
          <div className="max-w-xl w-full rounded-lg border bg-red-50 border-red-200 p-4 text-red-900">
            <h2 className="text-lg font-semibold">Something went wrong</h2>
            <p className="mt-2 text-sm">
              An unexpected error occurred. You can try reloading the UI below.
            </p>
            <pre className="mt-3 text-xs whitespace-pre-wrap overflow-auto bg-white p-2 rounded text-red-800">
              {String(this.state.error)}
            </pre>
            <div className="mt-4 flex gap-2">
              <button
                onClick={this.reset}
                className="px-3 py-1 rounded bg-background/80 dark:bg-background/60 border"
                type="button"
              >
                Try again
              </button>
              <button
                onClick={() => window.location.reload()}
                className="px-3 py-1 rounded bg-gray-100 border"
                type="button"
              >
                Reload page
              </button>
            </div>
          </div>
        </div>
      );
    }

    return <>{this.props.children}</>;
  }
}
