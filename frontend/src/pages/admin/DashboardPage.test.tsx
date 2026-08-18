import { describe, expect, it } from 'vitest';
import { screen } from '@testing-library/react';

import { renderWithProviders } from '../../test/test-utils';
import { futureDateKey, seedBooking } from '../../test/mocks/db';
import { DashboardPage } from './DashboardPage';

describe('DashboardPage (владелец: предстоящие встречи)', () => {
  it('отображает предстоящие встречи из GET /admin', async () => {
    seedBooking({
      dateKey: futureDateKey(1),
      time: '08:00',
      eventTypeId: 'consultation',
      guestName: 'Мария Иванова',
      guestContact: 'maria@example.com',
    });

    renderWithProviders(<DashboardPage />);

    expect(await screen.findByText('Консультация')).toBeInTheDocument();
    expect(screen.getByText('Мария Иванова')).toBeInTheDocument();
    expect(screen.getByText('maria@example.com')).toBeInTheDocument();
    expect(screen.getByText('30 мин')).toBeInTheDocument();
  });

  it('показывает пустое состояние, когда встреч нет', async () => {
    renderWithProviders(<DashboardPage />);

    expect(await screen.findByText('Нет предстоящих встреч')).toBeInTheDocument();
  });
});