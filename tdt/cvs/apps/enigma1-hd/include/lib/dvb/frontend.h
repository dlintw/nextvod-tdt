#ifndef __FRONTEND_H
#define __FRONTEND_H

/*
	 this handles all kind of frontend activity including
	 sec etc.
*/

#include <config.h>
#include <stdlib.h>

#if HAVE_DVB_API_VERSION < 3
#include <ost/dmx.h>
#include <ost/frontend.h>
#include <ost/sec.h>
#include <ost/video.h>
#define DEMOD_DEV "/dev/dvb/card0/frontend0"
#define SEC_DEV "/dev/dvb/card0/sec0"
#define QAM_AUTO		6
#define TRANSMISSION_MODE_AUTO	2
#define BANDWIDTH_AUTO		3
#define GUARD_INTERVAL_AUTO	4
#define HIERARCHY_AUTO		4
#else
#include <linux/dvb/dmx.h>
#include <linux/dvb/frontend.h>
#include <linux/dvb/video.h>
#define DEMOD_DEV "/dev/dvb/adapter0/frontend0"
#define SEC_DEV "/dev/dvb/adapter0/sec0"
#define CodeRate fe_code_rate_t
#define SpectralInversion fe_spectral_inversion_t
#define Modulation fe_modulation_t
#define TransmitMode fe_transmit_mode_t
#define BandWidth fe_bandwidth_t
#define GuardInterval fe_guard_interval_t
#define Hierarchy fe_hierarchy_t
#endif

#include <lib/base/ebase.h>
#include <lib/base/estring.h>

#define FEC_S2_QPSK_1_2 (fe_code_rate_t)(FEC_AUTO+1)		//10
#define FEC_S2_QPSK_2_3 (fe_code_rate_t)(FEC_S2_QPSK_1_2+1)	//11
#define FEC_S2_QPSK_3_4 (fe_code_rate_t)(FEC_S2_QPSK_2_3+1)	//12
#define FEC_S2_QPSK_5_6 (fe_code_rate_t)(FEC_S2_QPSK_3_4+1)	//13
#define FEC_S2_QPSK_7_8 (fe_code_rate_t)(FEC_S2_QPSK_5_6+1)	//14
#define FEC_S2_QPSK_8_9 (fe_code_rate_t)(FEC_S2_QPSK_7_8+1)	//15
#define FEC_S2_QPSK_3_5 (fe_code_rate_t)(FEC_S2_QPSK_8_9+1)	//16
#define FEC_S2_QPSK_4_5 (fe_code_rate_t)(FEC_S2_QPSK_3_5+1)	//17
#define FEC_S2_QPSK_9_10 (fe_code_rate_t)(FEC_S2_QPSK_4_5+1)	//18

#define FEC_S2_8PSK_1_2 (fe_code_rate_t)(FEC_S2_QPSK_9_10+1)	//19
#define FEC_S2_8PSK_2_3 (fe_code_rate_t)(FEC_S2_8PSK_1_2+1)	//20
#define FEC_S2_8PSK_3_4 (fe_code_rate_t)(FEC_S2_8PSK_2_3+1)	//21
#define FEC_S2_8PSK_5_6 (fe_code_rate_t)(FEC_S2_8PSK_3_4+1)	//22
#define FEC_S2_8PSK_7_8 (fe_code_rate_t)(FEC_S2_8PSK_5_6+1)	//23
#define FEC_S2_8PSK_8_9 (fe_code_rate_t)(FEC_S2_8PSK_7_8+1)	//24
#define FEC_S2_8PSK_3_5 (fe_code_rate_t)(FEC_S2_8PSK_8_9+1)	//25
#define FEC_S2_8PSK_4_5 (fe_code_rate_t)(FEC_S2_8PSK_3_5+1)	//26
#define FEC_S2_8PSK_9_10 (fe_code_rate_t)(FEC_S2_8PSK_4_5+1)	//27

static inline fe_modulation_t dvbs_get_modulation(fe_code_rate_t fec)
{
	if((fec < FEC_S2_QPSK_1_2) || (fec < FEC_S2_8PSK_1_2))
		return QPSK;
	else
#if HAVE_DVB_API_VERSION < 5
		return PSK8;
#else
		return PSK_8;
#endif
}

#if HAVE_DVB_API_VERSION >= 5
static inline fe_delivery_system_t dvbs_get_delsys(fe_code_rate_t fec)
{
	if(fec < FEC_S2_QPSK_1_2)
		return SYS_DVBS;
	else
		return SYS_DVBS2;
}

static inline fe_rolloff_t dvbs_get_rolloff(fe_delivery_system_t delsys)
{
	if(delsys == SYS_DVBS2)
		return ROLLOFF_25;
	else
		return ROLLOFF_35;
}
#endif

class eLNB;
class eTransponder;
class eSatellite;
class eSwitchParameter;

// DiSEqC Command Sequence Wrapper... for Multi API compatibility

struct eSecCmdSequence
{
	enum { TONE_OFF=SEC_TONE_OFF, TONE_ON=SEC_TONE_ON };

#if HAVE_DVB_API_VERSION < 3
	enum { VOLTAGE_OFF=SEC_VOLTAGE_OFF, VOLTAGE_13=SEC_VOLTAGE_13, VOLTAGE_18=SEC_VOLTAGE_18 };
	enum { NONE=SEC_MINI_NONE, TONEBURST_A=SEC_MINI_A, TONEBURST_B=SEC_MINI_B };
	secCommand *commands;
#else
	enum {VOLTAGE_13=SEC_VOLTAGE_13, VOLTAGE_18=SEC_VOLTAGE_18, VOLTAGE_OFF=SEC_VOLTAGE_OFF };
	enum {TONEBURST_A=SEC_MINI_A, TONEBURST_B=SEC_MINI_B, NONE };
	dvb_diseqc_master_cmd *commands;
#endif
	int numCommands;
	int toneBurst;
	int voltage;
	int continuousTone;
	bool increasedVoltage;
};

/**
 * \brief A frontend, delivering TS.
 *
 * A frontend is something like a tuner. You can tune to a transponder (or channel, as called with DVB-C).
 */
class eFrontend: public Object
{
	int type,
			fd,
#if HAVE_DVB_API_VERSION < 3
			secfd,
#else
			curContTone,
			curVoltage,
#endif
			needreset,
			lastcsw,
			lastucsw,
			lastToneBurst,
			lastRotorCmd,
			lastSmatvFreq,
			fenumber,
			curRotorPos;    // current Orbital Position
	bool tuned;

	eLNB *lastLNB;
	eTransponder *transponder;
	static eFrontend *frontend;
	eTimer rotorTimer1, rotorTimer2,
#if HAVE_DVB_API_VERSION >=3
				timeout,
#endif
				checkRotorLockTimer, checkLockTimer, updateTransponderTimer;
	eSocketNotifier *sn;
	int tries, noRotorCmd, wasLoopthrough, lostlockcount;
	Signal1<void, eTransponder*> tpChanged;
// ROTOR INPUTPOWER
	timeval rotorTimeout;
	int idlePowerInput;
	int runningPowerInput;
	int newPos;
// Non blocking rotor turning
	int DeltaA,
			voltage,
			increased;
///////////////////
#if HAVE_DVB_API_VERSION < 3
	FrontendParameters front;
#elif HAVE_DVB_API_VERSION >=5
	struct dvb_frontend_parameters front;
	dvb_frontend_info info;
#else
	struct dvb_frontend_parameters front;
	struct dvbfe_params fe_params;
#endif

	eFrontend(int type, const char *demod=DEMOD_DEV, const char *sec=SEC_DEV);

	int RotorUseTimeout(eSecCmdSequence& seq, eLNB *lnb);
	int RotorUseInputPower(eSecCmdSequence& seq, eLNB *lnb);
	void RotorStartLoop();
	void RotorRunningLoop();
	void RotorFinish(bool tune=true);
	int SendSequence( const eSecCmdSequence &seq );
	void updateTransponder();
	void readFeEvent(int what);
	int setFrontend();
	void checkRotorLock();
	void checkLock();
	void tuneFailed();
	void tuneOK();
	void tune_all(eTransponder *trans);
	void init_eFrontend(int type, const char *demod, const char *sec);
public:
	void abortTune() { transponder=0; }
	void disableRotor() { noRotorCmd = 1, lastRotorCmd=-1; } // no more rotor cmd is sent when tune
	void enableRotor() { noRotorCmd = 0, lastRotorCmd=-1; }  // rotor cmd is sent when tune
	int sendDiSEqCCmd( int addr, int cmd, eString params="", int frame=0xE0 );
	void getDelSys(int f, int m, char * &fec, char * &sys, char * &mod);

	Signal1<void, int> s_RotorRunning;
	Signal0<void> s_RotorStopped, s_RotorTimeout;
	Signal2<void, eTransponder*, int> tunedIn;
	~eFrontend();

	static int open(int type)
	{
		if (!frontend)
			frontend=new eFrontend(type);
		return 0;
	}

	static void close() { delete frontend; }

	static eFrontend *getInstance() { return frontend; }

	int Type() { return type; }

	int Status();
	int Locked() { return Status()&FE_HAS_LOCK; }
	void InitDiSEqC();
	int readInputPower();

	uint32_t BER();
	/**
	 * \brief Returns the signal strength (or AGC).
	 *
	 * Range is 0..65535 in linear scale.
	 */
	int SignalStrength();
	/**
	 * \brief Returns the signal-to-noise ratio.
	 *
	 * Range is 0..65535 in linear scale.
	 */
	int SNR();
	uint32_t UncorrectedBlocks();
	enum
	{
		polHor=0, polVert, polLeft, polRight
	};
	/** begins the tune operation and emits a "tunedIn"-signal */
	int tune_qpsk(eTransponder *transponder,
			uint32_t Frequency, 		// absolute frequency in kHz
			int polarisation, 		// polarisation (polHor, polVert, ...)
			uint32_t SymbolRate, 		// symbolrate in symbols/s (e.g. 27500000)
			uint8_t FEC_inner,		// FEC_inner according to ETSI (-1 for none, 0 for auto, but please don't use that)
			int Inversion,			// spectral invesion on(1)/off(0)
			int system,
			int modulation,
			int rolloff,
			int pilot,
			eSatellite &sat);       // complete satellite data... diseqc.. lnb ..switch

	int tune_qam(eTransponder *transponder,
			uint32_t Frequency, 		// absolute frequency in kHz
			uint32_t SymbolRate, 		// symbolrate in symbols/s (e.g. 6900000)
			uint8_t FEC_inner, 			// FEC_inner according to ETSI (-1 for none, 0 for auto, but please don't use that). normally -1.
			int inversion,					// spectral inversion on(1)/off(0)
			int QAM);								// Modulation according to etsi (1=QAM16, ...)

	int tune_ofdm(eTransponder *transponder,
			int centre_frequency,
			int bandwidth,
			int constellation,
			int hierarchy_information,
			int code_rate_hp,
			int code_rate_lp,
			int guard_interval,
			int transmission_mode,
			int inversion);

		// switches off as much as possible.
	int savePower();

	void setTerrestrialAntennaVoltage(bool state);
	struct dvb_frontend_event getEvent(void);
};


#endif
