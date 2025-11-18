using UnityEngine;

[RequireComponent(typeof(AudioSource))]

public class SoundManager : PersistentSingleton<SoundManager>
{
    [SerializeField] private AudioClip[] _soundsList;
    private AudioSource _source;

    private void Start()
    {
        _source = GetComponent<AudioSource>();
    }

    public static void PlaySound(SoundOf sound, float volume = 1)
    {
        Instance._source.PlayOneShot(Instance._soundsList[(int)sound], volume);
    }
}
