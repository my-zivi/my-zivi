import React from 'react';
import { Link } from 'react-router-dom';

export default function CardLink(props) {
  return (
    <Link to={props.to} className="card">
      {props.children}
    </Link>
  );
}
