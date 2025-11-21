using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class MenuFlows : MonoBehaviour
{
    [Header("GameplayScene")]
    [SerializeField] private string _nextScene;

    [Header("MenuGroups")]
    [SerializeField] private GameObject _landUI;
    [SerializeField] private GameObject _selectionUI;
    [SerializeField] private RectTransform _optionsPivot;

    [Header("EventSystem")]
    [SerializeField] private GameObject _fButtonLand;
    [SerializeField] private GameObject _fButtonSelection;
    [SerializeField] private GameObject _fButtonSettings;
    private GameObject _currentSelection;
    //private EventSystem _system;

    [Header("Settings")]
    [SerializeField] private AudioMixerGroup _musicMixer;
    [SerializeField] private AudioMixerGroup _effectsMixer;
    [SerializeField] private Slider _musicSlider;
    [SerializeField] private Slider _sfxSlider;

    [SerializeField] private LevelsManager _levelsManager;
    [SerializeField] private GameObject _displayGrp;
    //private PlayerInputManager _inputManager;
    private List<MESManager> _playersList;
    private MESManager _playerOne;

    public GameObject InitialSelection {  get { return _fButtonLand; } set { _fButtonSelection = value; } }
    public GameObject DisplayGrp {  get { return _displayGrp; } }

    private void Awake()
    {
        DontDestroyOnLoad(this);

        //_system = FindAnyObjectByType<EventSystem>();

        _landUI.SetActive(true);
        _selectionUI.SetActive(false);
        //_currentSelection = _fButtonLand;
        //StartCoroutine(CurrentSelectionDelay(_fButtonLand));
        _playersList = new List<MESManager>();
        _optionsPivot.rotation = Quaternion.identity;
    }

    private void OnEnable()
    {
        _musicSlider.value = PlayerPrefs.GetFloat("MusicVolume", 0);
        _sfxSlider.value = PlayerPrefs.GetFloat("SFXVolume", 0);

        _musicMixer.audioMixer.SetFloat("Music", Mathf.Log10(_musicSlider.value) * 20);
        _effectsMixer.audioMixer.SetFloat("Music", Mathf.Log10(_sfxSlider.value) * 20);
    }

    private void Start()
    {
        SoundManager.Instance.Play("MenuTheme");
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
        }
    }

    public void AddPlayerToList(MESManager player)
    {
        if (_playerOne == null)
        {
            _playerOne = player;
        }
        _playersList.Add(player);
    }

    public void PlayersSelection()
    {
        SoundManager.Instance.Play("AcceptButton");
        _landUI.SetActive(false);
        _selectionUI.SetActive(true);
        StartCoroutine(CurrentSelectionDelay(_fButtonSelection));
    }

    public void LandMenu()
    {
        SoundManager.Instance.Play("AcceptButton");
        _selectionUI.SetActive(false);
        _landUI.SetActive(true);
        StartCoroutine(CurrentSelectionDelay(_fButtonLand));
    }

    public void TransitionToMatch(TMP_Text prompt)
    {
        SoundManager.Instance.Play("AcceptButton");
        if (_playersList.Count < 2)
        {
            prompt.color = Color.red;
            prompt.text = new string("Not enough players. Plug another device");
        }
        else
        {
            prompt.color = Color.white;
            prompt.text = new string("GET READY!");
            LevelsManager.Instance.ChangeScene(_nextScene);
            foreach (var player in _playersList)
            {
                player.PlayerInput.SwitchCurrentActionMap("Player Controls");
            }
            _landUI.SetActive(false);
            _selectionUI.SetActive(false);
        }
    }

    public void ShowSettings()
    {
        SoundManager.Instance.Play("AcceptButton");
        StartCoroutine(CurrentSelectionDelay(_fButtonSettings));
        _optionsPivot.transform.DOLocalRotate(new Vector3(0, 75, 0), 0.75f).SetEase(Ease.OutSine);
    }
    public void HideSettings()
    {
        SoundManager.Instance.Play("AcceptButton");
        StartCoroutine(CurrentSelectionDelay(_fButtonLand));
        _optionsPivot.transform.DOLocalRotate(new Vector3(0, 0, 0), 0.75f).SetEase(Ease.OutSine);
    }

    public void SetMusicVolume()
    {
        float volume = _musicSlider.value;
        _musicMixer.audioMixer.SetFloat("Music", Mathf.Log10(volume) * 20);
        PlayerPrefs.SetFloat("MusicVolume", volume);
    }
    public void SetEffectsVolume()
    {
        float volume = _sfxSlider.value;
        _effectsMixer.audioMixer.SetFloat("SFX", Mathf.Log10(volume) * 20);
        PlayerPrefs.SetFloat("SFXVolume", volume);
    }

    public void TerminateGame()
    {
        SoundManager.Instance.Play("AcceptButton");
        LevelsManager.Instance.QuitGame();
    }

    IEnumerator CurrentSelectionDelay(GameObject selection)
    {
        yield return new WaitForSeconds(.2f);

        _playerOne.UpdateCurrentSelection(selection);
    }
}
