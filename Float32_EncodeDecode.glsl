///___________________________________________________________________
///
/// ENCODE / DECODE - 32Bit floating point number
///	- Assumes little-endian, does ".abgr" swizzles because of that
///	- Adding ".5" before flooring to 0 - 255 range to avoid issues when flooring near integer values.
///	- Without highp precision mantissa might lose accuracy from lower bits.
/// 	- 
///___________________________________________________________________
precision highp float;
float Decode(vec4 pack) {
	pack = floor(pack.abgr * 255.0 + .5);
	
	// Extract bits
	float bitSign = float(pack[0] > 127.0);	
	float bitExpn = float(pack[1] > 127.0);	
		pack[0] -= 128.0 * bitSign;
		pack[1] -= 128.0 * bitExpn;
	
	// Compute parts of number
	float exponent = pack[0] * 2.0 + bitExpn;
		exponent = pow(2.0, exponent - 127.0);
	float mantissa = 1.0; 
		mantissa += pack[1] / 128.0;
		mantissa += pack[2] / 32768.0;
		mantissa += pack[3] / 8388608.0;
		
	// Return result
	return (1.0 - 2.0 * bitSign) * exponent * mantissa;
}

float FLOAT_MAX = 1.70141184 * pow(10.0, +38.0);
float FLOAT_MIN = 1.17549435 * pow(10.0, -38.0);
vec4 Encode(float value) {
	// Special cases
	float absvalue = abs(value);
	if (absvalue <= FLOAT_MIN) return vec4(0.0);
	if (value >= +FLOAT_MAX) return vec4(127.0, 128.0, 0.0, 0.0).abgr / 255.0;
	if (value <= -FLOAT_MAX) return vec4(255.0, 128.0, 0.0, 0.0).abgr / 255.0; 
	vec4 pack;
	
	// Compute Exponent and Mantissa
	float exponent = floor(log2(absvalue));
	float mantissa = absvalue * pow(2.0, -exponent) - 1.0;
	
	// Pack Mantissa into bytes
	pack[1] = floor(mantissa * 128.0);		mantissa -= pack[1] / 128.0;
	pack[2] = floor(mantissa * 32768.0);	mantissa -= pack[2] / 32768.0;
	pack[3] = floor(mantissa * 8388608.0);
	
	// Pack Sing and Exponent into bytes
	float expbias = exponent + 127.0;
	pack[0] += floor(expbias / 2.0);		expbias -= pack[0] * 2.0;
	pack[1] += floor(expbias) * 128.0;
	pack[0] += 128.0 * float(value < 0.); // Sign
	return floor(pack.abgr + .5) / 255.0;
}
