using System.Collections.Generic;
using Unity.Cinemachine;
using UnityEngine;

    public class CameraShakeManager : Singleton<CameraShakeManager>
{
    /*[SerializeField] private CinemachineBasicMultiChannelPerlin _noise;

    [SerializeField] private float _blendSpeed = 10f;
    [SerializeField] private float _decaySpeed = 5f;
    [SerializeField] private float _maxTotalIntensity = 1f;
    
    private List<ShakeRequest> _activeShakes = new List<ShakeRequest>();
    private float _totalIntensity;
    private float _maxFrequency;*/

    [SerializeField] private CinemachineImpulseListener _listener;
    [SerializeField] private CinemachineCollisionImpulseSource _source;


    private void Start()
    {
        //_totalIntensity = 0f;
        //_maxFrequency = 0f;
    }
    private void Update()
    {
        /*for (int i = _activeShakes.Count - 1; i >= 0; i--)
        {
            var shake = _activeShakes[i];
            shake.Elapsed += Time.deltaTime;

            if (shake.Elapsed >= shake.Duration)
            {
                _activeShakes.RemoveAt(i);
                continue;
            }

            _totalIntensity += shake.Intensity;
            _maxFrequency = Mathf.Max(_maxFrequency, shake.Frequency);
        }

        _totalIntensity = Mathf.Clamp(_totalIntensity, 0f, _maxTotalIntensity);

        if (_activeShakes.Count == 0)
        {
            _noise.AmplitudeGain = Mathf.Lerp(_noise.AmplitudeGain, 0f, Time.deltaTime * _decaySpeed);
            _noise.FrequencyGain = Mathf.Lerp(_noise.FrequencyGain, 0f, Time.deltaTime * _decaySpeed);
        }
        else
        {
            _noise.AmplitudeGain = Mathf.Lerp(_noise.AmplitudeGain, _totalIntensity, Time.deltaTime * _blendSpeed);
            _noise.FrequencyGain = Mathf.Lerp(_noise.FrequencyGain, _maxFrequency, Time.deltaTime * _blendSpeed);
        }*/
    }

    /*public void AddShake(float baseIntensity, float baseDuration, float baseFrequency, int totalPlayersShooting = 4)
    {
        float multiplier = Mathf.Clamp01(totalPlayersShooting / 4f);
        float scaledIntensity = Mathf.Lerp(baseIntensity, _maxTotalIntensity, multiplier);
        float scaledDuration = baseDuration + (0.1f * totalPlayersShooting);

        _activeShakes.Add(new ShakeRequest(scaledIntensity, scaledDuration, baseFrequency));
    }

    private class ShakeRequest
    {
        public float Intensity;
        public float Duration;
        public float Frequency;
        public float Elapsed;

        public ShakeRequest(float intensity, float duration, float frequency)
        {
            Intensity = intensity;
            Duration = duration;
            Frequency = frequency;
            Elapsed = 0f;
        }
    }*/
}
