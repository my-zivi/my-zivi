import React from 'react';
import Header from './header';

export default function Layout(props) {
  return (
    <div id="app">
      <Header />
      <main id="content">{props.children}</main>
    </div>
  );
}
