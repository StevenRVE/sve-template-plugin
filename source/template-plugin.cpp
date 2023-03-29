#include "template-plugin.hpp"

START_NAMESPACE_DISTRHO

   /**
      Plugin class constructor.
      You must set all parameter values to their defaults, matching the value in initParameter().
    */
TemplatePlugin::TemplatePlugin()
    : Plugin(PARAM_COUNT, 0, 0) // parameters, programs, states
{
    /**
      Initialize all our parameters to their defaults.
      In this example all parameters have 0 as default, so we can simply zero them.
    */
}


// -------------------------------------------------------------------
// Init
// -------------------------------------------------------------------

/**
  Initialize the parameter @a index.
  This function will be called once, shortly after the plugin is created.
*/
void TemplatePlugin::initParameter(uint32_t index, Parameter& parameter)
{
    if (index >= PARAM_COUNT) { return; }

    struct ParamProps
    {
        float min, max, def;
        const char* name;
        const char* symbol;

    };

    const auto setParamProps = [](auto& param, ParamProps props)
    {
        param.hints = kParameterIsAutomatable | kParameterIsInteger;
        param.ranges.min = props.min;
        param.ranges.max = props.max;
        param.ranges.def = props.def;
        param.name = props.name;
        param.symbol = props.symbol;
    };

    switch (index)
    {
        // MASTER PARAMS
        case PARAM_GAIN:
            setParamProps(parameter, { .min=-0.0f, .max=2.0f, .def=1.0f, .name="Gain", .symbol="gain" });
            break;
        default:
            return 0;
    }
}

// -------------------------------------------------------------------
// Internal data
// -------------------------------------------------------------------

/**
  Get the current value of a parameter.
  The host may call this function from any context, including realtime processing.
*/
float TemplatePlugin::getParameterValue(uint32_t index) const
{
    switch (index)
    {
        // MASTER PARAMS
        case PARAM_GAIN:
            return gain;
        default:
            return 0;
    }
}

/**
  Change a parameter value.
  The host may call this function from any context, including realtime processing.
  When a parameter is marked as automable, you must ensure no non-realtime
  operations are performed.
*/
void TemplatePlugin::setParameterValue(uint32_t index, float value)
{
    switch (index)
    {
    // MASTER PARAMS
    case PARAM_GAIN:
        gain = value;
        break;
    default:
        break;
    }
}

// -------------------------------------------------------------------
// methods
// -------------------------------------------------------------------

// -------------------------------------------------------------------
// Process

void TemplatePlugin::activate()
{
    // plugin is activated
}

void TemplatePlugin::deactivate()
{
    // plugin is deactivated
}

/**
  Run/process function for plugins with MIDI input.
*/
void TemplatePlugin::run(const float**, float**, uint32_t nframes)
{
    // run
}

// -------------------------------------------------------------------
// callbacks

/**
    Optional callback to inform the plugin about a sample rate change.
    This function will only be called when the plugin is deactivated.
*/
void TemplatePlugin::sampleRateChanged(double newSampleRate)
{
    (void)newSampleRate;
}

// -----------------------------------------------------------------------

Plugin* createPlugin()
{
    return new TemplatePlugin();
}

// -----------------------------------------------------------------------

END_NAMESPACE_DISTRHO
