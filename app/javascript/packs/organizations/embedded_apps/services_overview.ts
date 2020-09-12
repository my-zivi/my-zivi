import App from '../../../js/organizations/services/embedded_app/components/App';
import EmbeddedApp from '../../../js/shared/EmbeddedApp';
import { Component } from 'preact';

new EmbeddedApp('#planning-app', <typeof Component>App).install();
