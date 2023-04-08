# **FM Broadcasting**

## General Backround

### The Radio Spectrum 
The radio spectrum is the part of the electromagnetic spectrum with frequencies from 3 Hz to 3,000 GHz (3 THz). Electromagnetic waves in this frequency range, called radio waves, are widely used in modern technology, particularly in telecommunication

### Modulation
In electronics and telecommunications, modulation is the process of varying one or more properties of a periodic waveform, called the carrier signal, with a separate signal called the modulation signal that typically contains information to be transmitted. For example, the modulation signal might be an audio signal representing sound. The carrier is usually a higher in frequency than the modulation signal.

### Frequency modulation
Frequency modulation (FM) is the encoding of information in a carrier wave by **varying the instantaneous frequency** of the wave and it can be described by the following formula: 

${s(t) = A_c \cos\left(2\pi f_c t + 2\pi k_f\int_{0}^{t} m(\tau) d\tau\right)}$ while ${m(\tau)}$ is the information signal

### Frequency Deviation
${f_\Delta}$ is used in FM radio to describe the difference between the minimum or maximum extent of a frequency modulated signal, and the nominal center or carrier frequency.
For a **stereo broadcast**, the maximum permitted carrier deviation is invariably ±75 kHz.
FM radio signals may also include additional subcarriers for auxiliary data, such as Radio Data System (RDS), which has a maximum modulating frequency of 60 kHz

### Bandwidth 
The bandwidth of a FM transmission is given by the Carson bandwidth rule which is the sum of twice the maximum deviation and twice the maximum modulating frequency. For a transmission that includes RDS this would be 2x75kHz + 2x60kHz = 270 kHz. This is also known as the Necessary Bandwidth

### Radio broadcasting
Radio broadcasting is the broadcasting of audio by radio waves belonging to a public audience.

### FM broadcasting
FM broadcasting is the method of radio broadcasting that uses frequency modulation (FM).

### Broadcast Bands 
Throughout the world, the FM broadcast band falls within the VHF part of the radio spectrum. Usually 87.5 to 108.0 MHz is used

### FM Stereo
FM stereo is a method of transmitting stereo audio using frequency modulation (FM) radio waves. In FM stereo, the audio signals for the left and right channels are combined and modulated onto a subcarrier wave, which is then added to the main FM carrier wave.

The formula for FM stereo is:

${V(t) = A_c\cdot[1 + k_a m(t)]\cdot cos[2πf_ct + φ_c + k_p m(t)]}$

where ${V(t)}$ is the instantaneous voltage of the FM signal, ${A_c}$ is the amplitude of the carrier wave, ${k_a}$ and ${k_p}$ are the audio and pilot frequency deviation constants, ${m(t)}$ is the audio signal, ${f_c}$ is the carrier frequency, and ${φ_c}$ is the phase of the carrier wave.

The pilot signal, which is a fixed frequency tone, is added to the subcarrier wave to allow for stereo decoding. The stereo signal is then demodulated by extracting the left and right audio signals from the subcarrier wave using phase and amplitude detection.

### The Spectrum Specification for Transmittingg FM Stereo
![image](https://user-images.githubusercontent.com/89732669/230732336-65af6f99-7499-4e46-aba0-49b160a3148f.png)



## Project's Goal
To implement FM broadcasting blocks for mono and stereo audio streams.

The communication chain blocks that are implemented are given below:

<img width="433" alt="image" src="https://user-images.githubusercontent.com/89732669/210272755-efd5b0da-2fab-486a-8df0-92ff155df73f.png">


<img width="449" alt="image" src="https://user-images.githubusercontent.com/89732669/210272702-52d77ea5-0558-4208-ba4a-35bce9ba9f9b.png">


### Block Diagram Explanation for Mono Stream
**Transmitter** 

• Upsample to 200KHz- to squeeze the spectrum so it could fit in the desired frequency
domain

• LPF with c.o.f 15KHz- to filter the signal for the desired BW according to specification

• FM modulation- modulate the signal

• Upsample to 1MHz- upsample for the USRP transmission

• LPF with c.o.f 90kHz- get the 98% of the signal energy according to Carson’s rule

**Receiver**

• LPF with c.o.f 90kHz- get the 98% of the signal energy according to Carson’s rule

• Downsample to 200KHz- working frequency for base band

• FM demodulation- demodulate the signal

• LPF with c.o.f 15KHz- to filter the signal for the desired BW according to specification

• Downsample to 48KHz- returning to the audio original sample rate

### Block Diagram Explanation for Stereo Stream
**Transmitter**

• Upsample to 200KHz- to squeeze the spectrum so it could fit in the desired frequency
domain

• LPF with c.o.f 15KHz- to filter the signal for the desired BW according to specification

• Build Stereo Stream- create the stereo stream according to the FM broadcasting
specification

• FM modulation- modulate the signal

• Upsample to 1MHz- upsample for the USRP transmission

• LPF with c.o.f 128kHz- get the 98% of the signal energy according to Carson’s rule

**Receiver**

• LPF with c.o.f 128kHz- get the 98% of the signal energy according to Carson’s rule

• Downsample to 200KHz- working frequency for base band

• FM demodulation- demodulate the signal

• Recover phase- offset the spectrally uneven demodulated noise (this result will be used
to filter the stereo part from the spectrum)

• LPF with c.o.f 15KHz- to filter the signal for the desired BW according to specification

  o One LPF with Gain=2 to fix the sine multiplication
  
• Downsample to 48KHz or 44.1KHz- returning the left and right channels to their original
sample rate
