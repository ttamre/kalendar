import './css/normalize.css';
import './css/tailwind.css';
import './css/skeleton.css';


function generateTimeSlots() {
	const timeSlots = [];
	const startTime = new Date();
	const endTime = new Date();

	startTime.setHours(8, 0, 0, 0); // Start at 8:00 AM
	endTime.setHours(18, 0, 0, 0);  // End at 6:00 PM

	while (startTime <= endTime) {
		const slot = startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
		timeSlots.push(slot);
		startTime.setMinutes(startTime.getMinutes() + 30);
	}

	return timeSlots;
}

function App() {
	return (
		<div className="calendar container p-5 mx-auto flex items-center rounded-xl">
			<div className="row">
				<div className="two columns">......</div>
				<h6 className="two columns">TIRES 1</h6>
				<h6 className="two columns">TIRES 2</h6>
				<h6 className="two columns">MECH 1</h6>
				<h6 className="two columns">MECH 2</h6>
				<h6 className="two columns">ALIGNMENT</h6>
			</div>

			{generateTimeSlots().map((time, index) => (
				<div key={index} className="row">
					<div className="two columns">{time}</div>
					{/* appointments go here */}
					<div className="appointment two columns">swap</div>
					<div className="appointment two columns">repair</div>
					<div className="appointment two columns">brakes</div>
					<div className="appointment two columns">front end</div>
					<div className="appointment two columns">alignment</div>
				</div>
			))}
		</div>
	);
}


export default App;