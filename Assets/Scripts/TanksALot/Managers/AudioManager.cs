using UnityEngine;

public enum TypeOfSound
{
    TankIdle,
    TankMovement,
    Explosion,
    Cannon,
    Victory,
    Heal,
    Music,
    Mine,
    Death,
    ToyBlock,
    SpawningBlock,
    ToolBox,
}

[RequireComponent(typeof(AudioSource))]

public class AudioManager : MonoBehaviour
{
    [SerializeField] private AudioClip[] _soundsList;
    private static AudioManager instance;
    private AudioSource _source;

    private void Awake()
    {
        instance = this;
    }

    private void Start()
    {
        _source = GetComponent<AudioSource>();
    }

    public static void PlaySound(TypeOfSound sound, float volume = 1)
    {
        instance._source.PlayOneShot(instance._soundsList[(int)sound], volume);
    }
}
