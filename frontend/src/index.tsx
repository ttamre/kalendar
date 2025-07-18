import './css/normalize.css';
import './css/skeleton.css';
import './css/custom.css';

import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

import CalendarPage from './pages/CalendarPage';
import StatsPage from './pages/StatsPage';
import BookingsPage from './pages/BookingsPage';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<CalendarPage />} />
        <Route path="/stats" element={<StatsPage />} />
        <Route path="/bookings" element={<BookingsPage />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
