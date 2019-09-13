import * as React from 'react';
import { Link } from 'react-router-dom';
import { OverviewTable } from '../../../layout/OverviewTable';
import { PaymentStore } from '../../../stores/paymentStore';
import { Payment } from '../../../types';
import { Formatter } from '../../../utilities/formatter';

const COLUMNS = [
  {
    id: 'created_at',
    label: 'Datum',
    format: (payment: Payment) => new Formatter().formatDate(PaymentStore.convertPaymentTimestamp(payment.payment_timestamp)),
  },
  {
    id: 'amount',
    label: 'Betrag',
    format: (payment: Payment) => new Formatter().formatCurrency(payment.total),
  },
];

export const PaymentsTable = ({ payments, emptyNotice }: { payments: Payment[], emptyNotice: string }) => {
  if (payments.length <= 0) {
    return <span className="text-muted">{emptyNotice}</span>;
  } else {
    return (
      <OverviewTable
        columns={COLUMNS}
        data={payments}
        renderActions={({ payment_timestamp }: Payment) => <Link to={'/payments/' + payment_timestamp}>Details</Link>}
      />
    );
  }
};
