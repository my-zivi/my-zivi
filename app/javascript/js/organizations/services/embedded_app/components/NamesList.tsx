import { FunctionalComponent } from 'preact';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import React from 'preact/compat';

const NamesList: FunctionalComponent<{ servicesList: ServicesList }> = ({ servicesList }) => {
  return (
    <div className="names-list">
      {servicesList.services.map((service) => (
        <div className="name-row">
          {service.civilServant.fullName}
        </div>
      ))}
    </div>
  );
};

export default NamesList;
