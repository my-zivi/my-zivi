import { Component } from 'preact';
import App from '../../../js/organizations/services/embedded_app/components/App';
import EmbeddedApp from '../../../js/shared/EmbeddedApp';

new EmbeddedApp('#planning-app', <typeof Component>App).install();
