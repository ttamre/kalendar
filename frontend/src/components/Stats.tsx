/* Calendar Component */

import { useState, useEffect } from "react";


type Stat = {
    service: string;
    booked: number;
    at_shop: number;
    completed: number;
    cancelled: number;
    total_bookings: number;
    cancellation_rate: number;
};


export default function Stats() {
    const [stats, setStats] = useState<Stat[]>([]);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        fetchStats()
            .then(data => setStats(data))
            .catch(err => setError(err.message));
    }, []);

    if (error) {
        return <div className="error container">Error: {error}</div>;
    }

    return (
        <div className="container">
            <h2>stats</h2>
            <table>
                <thead>
                    <tr>
                        <th className="stats">service</th>
                        <th className="stats">in progress</th>
                        <th className="stats">cancelled</th>
                        <th className="stats">completed</th>
                        <th className="stats">total</th>
                        {/* <th>cancellation %</th> */}
                    </tr>
                </thead>
                <tbody>
                    {stats.map((stat, index) => (
                        <tr key={index}>
                            <td className="stats grey">{stat.service}</td>
                            <td className="stats grey">{stat.booked + stat.at_shop}</td>
                            <td className="stats red">{stat.cancelled}</td>
                            <td className="stats green">{stat.completed}</td>
                            <td className="stats grey">{stat.total_bookings}</td>
                            {/* <td className="stats red">{stat.cancellation_rate.toFixed(2)}%</td> */}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

async function fetchStats() {
    const response = await fetch('/api/stats');
    if (!response.ok) {
        throw new Error(`Failed to fetch stats(${response.status} ${response.statusText})`);
    }
    return response.json();
}