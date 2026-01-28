-- Automatically set SOURCE_TRC and TARGET_TRC for CAS.glsl and CAS-scaled.glsl

function set_cas_gamma_transfer_opt(name, value)
	if value == nil then
		return
	end

	glsl_shader_opts = mp.get_property("options/glsl-shader-opts")
	if string.len(glsl_shader_opts) > 0 then
		glsl_shader_opts = glsl_shader_opts .. ','
	end

	if value == "rec709" then
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=1,CAS/TARGET_TRC=1,CAS-scaled/SOURCE_TRC=1,CAS-scaled/TARGET_TRC=1')
	elseif value == "pq" then
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=2,CAS/TARGET_TRC=2,CAS-scaled/SOURCE_TRC=2,CAS-scaled/TARGET_TRC=2')
	elseif value == "srgb" then
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=3,CAS/TARGET_TRC=3,CAS-scaled/SOURCE_TRC=3,CAS-scaled/TARGET_TRC=3')
	elseif value == "bt.1886" then
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=4,CAS/TARGET_TRC=4,CAS-scaled/SOURCE_TRC=4,CAS-scaled/TARGET_TRC=4')
	elseif value == "hlg" then
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=5,CAS/TARGET_TRC=5,CAS-scaled/SOURCE_TRC=5,CAS-scaled/TARGET_TRC=5')
	elseif string.match(value, "gamma%d+%.?%d*") == value then
		local gamma_val = string.sub(value, 6)
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=6,CAS/TARGET_TRC=6,CAS-scaled/SOURCE_TRC=6,CAS-scaled/TARGET_TRC=6,CAS/SOURCE_CUSTOM_GAMMA=' .. gamma_val .. ',CAS/TARGET_CUSTOM_GAMMA=' .. gamma_val .. ',CAS-scaled/SOURCE_CUSTOM_GAMMA=' .. gamma_val .. ',CAS-scaled/TARGET_CUSTOM_GAMMA=' .. gamma_val)
	else
		mp.set_property("file-local-options/glsl-shader-opts", glsl_shader_opts .. 'CAS/SOURCE_TRC=0,CAS/TARGET_TRC=0,CAS-scaled/SOURCE_TRC=0,CAS-scaled/TARGET_TRC=0')
	end
end
mp.observe_property("video-params/gamma", "string", set_cas_gamma_transfer_opt)
