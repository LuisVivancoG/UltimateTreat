using DG.Tweening.Core.Easing;
using System.Collections;
using UnityEditor.PackageManager.Requests;
using UnityEngine;

public class CharacterVisualsBehaviour : MonoBehaviour
{
    [Header ("Assign chosen material")]
    [SerializeField] private MeshRenderer _renderer;
    [SerializeField] private AllColorsPicker _allColorsPicker;
    private MaterialPropertyBlock _colorPBlock;
    //private PlayerController _currentPlayer;

    [Header ("Flash effect")]
    [SerializeField] private float _flashDuration;
    [SerializeField] private int _numberOfFlashes;

    private void Awake()
    {
        _colorPBlock = new MaterialPropertyBlock();
    }

    private void Start()
    {
        var newColor = RandomColor();
        _renderer.GetPropertyBlock(_colorPBlock);
        _colorPBlock.SetColor("_Clothing_Tint", RandomColor());
        _renderer.SetPropertyBlock(_colorPBlock);
        Debug.Log("Color applied" + newColor);
    }

    private int RandomInt()
    {
        int newSelection = Random.Range(0, _allColorsPicker.ColorsAvailable.Length);
        return newSelection;
    }

    private Color RandomColor()
    {
        return new Color(Random.value, Random.value, Random.value, 1f);
    }

    public void FlashMaterial()
    {
        StartCoroutine(FlashRoutine(_numberOfFlashes));
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
        //_isVulnerable = true;
    }

    public void VulnerabilitySequence()
    {
        StartCoroutine(FlickrColor());
    }

    IEnumerator FlickrColor()
    {
        float time = 0;
        _renderer.material.SetColor("_Clothing_Tint", Color.red);

        float singleFlashDuration = _flashDuration / (_numberOfFlashes * 2f);

        while (true)
        {
            //var sineValue = Mathf.PingPong(time, 1);

            _renderer.material.SetInt("_Flash", 1);
            yield return new WaitForSeconds(singleFlashDuration);
            _renderer.material.SetInt("_Flash", 0);

            yield return null;
        }
    }
}
