import * as Sentry from '@sentry/browser';

const { sentryConfig } = window;
Sentry.init(sentryConfig);

window.Sentry = Sentry;
