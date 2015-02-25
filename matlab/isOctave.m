function res = isOctave()
	res = 0 ~= exist('octave_config_info');
end