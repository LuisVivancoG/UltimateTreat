using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Haptics;

public class RumbleManager : Singleton<RumbleManager>
{
    // Functionality:
    // 
    // - Rumble pulse (on hit). low-high, duration
    // - Rumble constant (low hp). low-high, frequency 
    // - Rumble linear (on countdown). low-high, increment/decrease, duration
    // - Stop rumble/routine
    //private PlayerInputMultiplayer _playerRequested;
    //private RumblePattern _currentRumble;

    private Coroutine _rumbleCoroutine;

    public void RumblePulse(float intensity, float duration, Gamepad requester)
    {
        requester.SetMotorSpeeds(intensity, intensity);
        StartCoroutine(EndPulse(duration, requester));
    }

    public void RumbleConstant(float maxIntensity, float frequency, Gamepad requester)
    {
        if (_rumbleCoroutine != null)
        {
            StopCoroutine(_rumbleCoroutine);
            _rumbleCoroutine = null;
        }

        _rumbleCoroutine = StartCoroutine(WaveIntensity(maxIntensity, frequency, requester));

        //requester.SetMotorSpeeds(intensity, intensity);

        //StartCoroutine(SineWave(isVibrating, intensity, frequency, requester));

    }

    public void RumbleLinear(float intensity, float duration, float increment, Gamepad requester)
    {

    }

    public void StopAllMotions(Gamepad requester)
    {
        StopAllCoroutines();
        //EndPulse(0, requester);
    }

    IEnumerator WaveIntensity(float maxIntensity, float frequency, Gamepad requester)
    {
        float time = 0;

        while (true)
        {
            float sineValue = Mathf.Sin(time * frequency * 2f * Mathf.PI);
            float intensity = Mathf.Abs(sineValue) * maxIntensity;

            requester?.SetMotorSpeeds(intensity, intensity);

            time += Time.deltaTime;

            yield return null;
        }
    }

    IEnumerator EndPulse(float lapse, Gamepad requester)
    {
        yield return new WaitForSeconds(lapse);
        requester.SetMotorSpeeds(0, 0);
    }
}
