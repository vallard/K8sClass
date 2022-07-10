import React from 'react';

const Emoji = ({ label, emoji }) =>
	<span role="img" aria-label={label ? label : ""}>
		{emoji}
	</span>

export default Emoji
