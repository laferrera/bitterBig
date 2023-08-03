  public enum WAVEFORM{
        WAVE_SIN,
        WAVE_TRI,
        WAVE_SAW,
        WAVE_RAMP,
        WAVE_SQUARE,
        WAVE_POLYBLEP_TRI,
        WAVE_POLYBLEP_SAW,
        WAVE_POLYBLEP_SQUARE,
        WAVE_LAST,
    };

class Oscillator{
        float sr_;
        float sr_recip_;
        float freq_      = 100.0f;
        float amp_       = 0.5f;
        float pw_        = 0.5f;
        float pw_rad_    = pw_ * TWO_PI;
        float phase_     = 0.0f;
        float phase_inc_ = CalcPhaseInc(freq_);
        float last_out_ = 0.0f;
        //int waveform_  = 0;//WAVE_SIN;
        WAVEFORM waveform_  = WAVEFORM.WAVE_SIN;        
        boolean eoc_     = true;
        boolean eor_     = true;
    
  
  Oscillator(float sampleRate){
      sr_  = sampleRate;
      sr_recip_ = 1.0f / sampleRate;  
  }
  
  float CalcPhaseInc(float f){
    return (TWO_PI * f) * sr_recip_;
  }
  
  void SetFreq(float f){
    freq_      = f;
    phase_inc_ = CalcPhaseInc(f);
  }
  void SetAmp(float a){
    amp_      = a;
  }
 
  
float Process()
{
    float out, t;
    switch(waveform_)
    {
        case WAVE_SIN: out = sin(phase_); break;
        case WAVE_TRI:
            t   = -1.0f + (2.0f * phase_ * 1/TWO_PI);
            //out = 2.0f * (fabsf(t) - 0.5f);
            out = 2.0f * (abs(t) - 0.5f);
            break;
        case WAVE_SAW:
            out = -1.0f * (((phase_ * 1/TWO_PI * 2.0f)) - 1.0f);
            break;
        case WAVE_RAMP: out = ((phase_ * 1/TWO_PI * 2.0f)) - 1.0f; break;
        case WAVE_SQUARE: out = phase_ < pw_rad_ ? (1.0f) : -1.0f; break;
        case WAVE_POLYBLEP_TRI:
            t   = phase_ * 1/TWO_PI;
            out = phase_ < PI ? 1.0f : -1.0f;
            out += Polyblep(phase_inc_, t);
            //out -= Polyblep(phase_inc_, mod(t + 0.5f, 1.0f));
            out -= Polyblep(phase_inc_, (t + 0.5f) % (1.0f));            
            // Leaky Integrator:
            // y[n] = A + x[n] + (1 - A) * y[n-1]
            out       = phase_inc_ * out + (1.0f - phase_inc_) * last_out_;
            last_out_ = out;
            break;
        case WAVE_POLYBLEP_SAW:
            t   = phase_ * 1/TWO_PI;
            out = (2.0f * t) - 1.0f;
            out -= Polyblep(phase_inc_, t);
            out *= -1.0f;
            break;
        case WAVE_POLYBLEP_SQUARE:
            t   = phase_ * 1/TWO_PI;
            out = phase_ < pw_rad_ ? 1.0f : -1.0f;
            out += Polyblep(phase_inc_, t);
            //out -= Polyblep(phase_inc_, mod(t + (1.0f - pw_), 1.0f));
            out -= Polyblep(phase_inc_, (t + (1.0f - pw_)) % (1.0f));            
            out *= 0.707f; // ?
            break;
        default: out = 0.0f; break;
    }
    phase_ += phase_inc_;
    if(phase_ > TWO_PI)
    {
        phase_ -= TWO_PI;
        eoc_ = true;
    }
    else
    {
        eoc_ = false;
    }
    eor_ = (phase_ - phase_inc_ < PI && phase_ >= PI);

    return out * amp_;
}
  
float Polyblep(float phase_inc, float t){
    float dt = phase_inc * 1/TWO_PI;
    if(t < dt)
    {
        t /= dt;
        return t + t - t * t - 1.0f;
    }
    else if(t > 1.0f - dt)
    {
        t = (t - 1.0f) / dt;
        return t * t + t + t + 1.0f;
    }
    else
    {
        return 0.0f;
    }
}
  
  
}
