using DG.Tweening;
using System.Collections;
using UnityEngine;

public class CharacterVisualsBehaviour : MonoBehaviour
{
    [Header ("Assign chosen material")]
    [SerializeField] private MeshRenderer _renderer;
    [SerializeField] private GameObject _hitStopGO;
    private MaterialPropertyBlock _colorPBlock;
    //private PlayerController _currentPlayer;

    [Header ("Flash effect")]
    [SerializeField] private float _flashDuration;
    [SerializeField] private int _numberOfFlashes;

    [Header ("Particles")]
    [SerializeField] ParticleSystem _muzzle;

    private void Awake()
    {
        _colorPBlock = new MaterialPropertyBlock();
    }

    private void Start()
    {
        //_renderer.GetPropertyBlock(_colorPBlock);
        //_colorPBlock.SetColor("_Clothing_Tint", RandomColor());
        //_renderer.SetPropertyBlock(_colorPBlock);
        //Debug.Log("Color applied" + newColor);
    }

    public void SetColor(Color colorChosen)
    {
        _renderer.GetPropertyBlock(_colorPBlock);
        _colorPBlock.SetColor("_Clothing_Tint", colorChosen);
        _renderer.SetPropertyBlock(_colorPBlock);
    }

    public void PlayMuzzleParticles(Vector3 location, Vector3 rotation)
    {
        _muzzle.transform.position = location;
        _muzzle.transform.localEulerAngles = rotation;
        _muzzle.Play();
    }

    public void OnHitStop()
    {
        ShakeVisuals();
        StartCoroutine(FlashRoutine(_numberOfFlashes));
    }

    private void ShakeVisuals()
    {
        _hitStopGO.transform.DOShakePosition(1f, .3f);
    }

    IEnumerator FlashRoutine(int flashes)
    {
        float singleFlashDuration = _flashDuration / (flashes * 2f);

        for (int i = 0; i < flashes; i++)
        {
            _renderer.material.SetInt("_Flash", 1);
            yield return new WaitForSeconds(singleFlashDuration);
            _renderer.material.SetInt("_Flash", 0);
            yield return new WaitForSeconds(singleFlashDuration);
        }
    }

    public void VulnerabilitySequence()
    {
        StartCoroutine(FlickrColor());
    }

    IEnumerator FlickrColor()
    {
        _renderer.material.SetColor("_Clothing_Tint", Color.red);

        float singleFlashDuration = _flashDuration / (_numberOfFlashes * 2f);

        while (true)
        {
            _renderer.material.SetInt("_Flash", 1);
            yield return new WaitForSeconds(singleFlashDuration);
            _renderer.material.SetInt("_Flash", 0);

            yield return null;
        }
    }
}
