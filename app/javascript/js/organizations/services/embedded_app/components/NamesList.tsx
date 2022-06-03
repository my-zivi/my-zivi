import { FunctionalComponent } from 'preact';
import React from 'preact/compat';
import ServicesList from '~/js/organizations/services/embedded_app/models/ServicesList';

const NamesList: FunctionalComponent<{ servicesList: ServicesList }> = ({ servicesList }) => (
    <div className="names-list">
      {servicesList.services.map((service) => (
        <div className="name-row">
          <span>{service.civilServant.fullName}</span>
        </div>
      ))}
    </div>
);

export default NamesList;
