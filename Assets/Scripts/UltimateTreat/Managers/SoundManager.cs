using System;
using UnityEngine;
using UnityEngine.Audio;

public class SoundManager : PersistentSingleton<SoundManager>
{
    [SerializeField] private Sound[] _sounds;
    [SerializeField] private GameObject _musicGrp;
    [SerializeField] private GameObject _effectsGrp;
    [SerializeField] private AudioMixerGroup _musicMixer;
    [SerializeField] private AudioMixerGroup _effectsMixer;
    [SerializeField] private AudioMixerSnapshot _snapshotPaused, _snapshotUnpaused;

    private void Start()
    {
        foreach (var sound in _sounds)
        {
            switch (sound.Type)
            {
                case SoundType.Music:
                    sound.Source = _musicGrp.AddComponent<AudioSource>();
                    sound.Source.outputAudioMixerGroup = _musicMixer;                    
                    break;

                case SoundType.Effect:
                    sound.Source = _effectsGrp.AddComponent<AudioSource>();
                    sound.Source.outputAudioMixerGroup = _effectsMixer;
                    break;
            }
            sound.Source.clip = sound.Clip;
            sound.Source.volume = sound.Volume;
            sound.Source.pitch = sound.Pitch;
            sound.Source.loop = sound.Loop;
            sound.Source.spatialBlend = sound.SpatialBlend;
            sound.Source.priority = sound.Priority;
            sound.Source.playOnAwake = sound.PlayOnAwake;
        }
    }
    public void Play(string name)
    {
        Sound s = Array.Find(_sounds, sound => sound.Name == name);
        if (s == null)
        {
            Debug.LogWarning($"Missing sound {name} in {_sounds}");
            return;
        }
        s.Source.Play();
    }

    public void PauseMixer()
    {
        _snapshotPaused.TransitionTo(.5f);
    }

    public void UnpauseMixer()
    {
        _snapshotUnpaused.TransitionTo(.5f);
    }
}
