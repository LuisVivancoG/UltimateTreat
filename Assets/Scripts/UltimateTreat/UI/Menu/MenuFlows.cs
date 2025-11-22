using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

public class MenuFlows : PersistentSingleton<MenuFlows>
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
    [SerializeField] private GameObject _displayGrp;
    //private PlayerInputManager _inputManager;
    private List<MESManager> _playersList;
    private MESManager _playerOne;
    private SoundManager _audioManager;
    private LevelsManager _levelsManager;
    private GameManager _gManager;

    public GameObject InitialSelection {  get { return _fButtonLand; } set { _fButtonSelection = value; } }
    public GameObject DisplayGrp {  get { return _displayGrp; } }

    private void OnEnable()
    {
        _musicSlider.value = PlayerPrefs.GetFloat("MusicVolume", 0);
        _sfxSlider.value = PlayerPrefs.GetFloat("SFXVolume", 0);

        _musicMixer.audioMixer.SetFloat("Music", Mathf.Log10(_musicSlider.value) * 20);
        _effectsMixer.audioMixer.SetFloat("Music", Mathf.Log10(_sfxSlider.value) * 20);
    }

    private void Start()
    {
        _landUI.SetActive(true);
        _selectionUI.SetActive(false);
        _playersList = new List<MESManager>();
        _optionsPivot.rotation = Quaternion.identity;

        _gManager = FindAnyObjectByType<GameManager>();
        if (_gManager == null)
        {
            _gManager = GameManager.Instance;
        }

        _levelsManager = FindAnyObjectByType<LevelsManager>();
        if (_levelsManager == null)
        {
            _levelsManager = LevelsManager.Instance;
        }

        _audioManager = FindAnyObjectByType<SoundManager>();
        if(_audioManager == null)
        {
            _audioManager = SoundManager.Instance;
        }

        _audioManager.Play("MenuTheme");
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
        _audioManager.Play("AcceptButton");
        _landUI.SetActive(false);
        _selectionUI.SetActive(true);
        StartCoroutine(CurrentSelectionDelay(_fButtonSelection));
    }

    public void LandMenu()
    {
        _audioManager.Play("AcceptButton");
        _selectionUI.SetActive(false);
        _landUI.SetActive(true);
        StartCoroutine(CurrentSelectionDelay(_fButtonLand));
    }

    public void TransitionToMatch(TMP_Text prompt)
    {
        _audioManager.Play("AcceptButton");
        if (_playersList.Count < 2)
        {
            prompt.color = Color.red;
            prompt.text = new string("Not enough players. Plug another device");
        }
        else
        {
            prompt.color = Color.white;
            prompt.text = new string("GET READY!");
            _levelsManager.ChangeScene(_nextScene);
            RemoveDisplayedPlayer();
            foreach (var player in _playersList)
            {
                player.PlayerInput.SwitchCurrentActionMap("Player Controls");
            }
            _landUI.SetActive(false);
            _selectionUI.SetActive(false);

            StartCoroutine(LoadMatch());
        }
    }

    void RemoveDisplayedPlayer()
    {
        var childs = _displayGrp.transform.childCount;
        var gOList = new List<GameObject>();

        for (int i = 0; i < childs; i++)
        {
            gOList.Add(_displayGrp.transform.GetChild(i).gameObject);
        }
        foreach (var child in gOList)
        {
            Destroy(child.gameObject);
        }
    }

    IEnumerator LoadMatch()
    {
        yield return new WaitForSeconds(1);

        _gManager.StartGame();
    }

    public void ShowSettings()
    {
        _audioManager.Play("AcceptButton");
        StartCoroutine(CurrentSelectionDelay(_fButtonSettings));
        _optionsPivot.transform.DOLocalRotate(new Vector3(0, 75, 0), 0.75f).SetEase(Ease.OutSine);
    }
    public void HideSettings()
    {
        _audioManager.Play("AcceptButton");
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
        _audioManager.Play("AcceptButton");
        _levelsManager.QuitGame();
    }

    IEnumerator CurrentSelectionDelay(GameObject selection)
    {
        yield return new WaitForSeconds(.2f);

        _playerOne.UpdateCurrentSelection(selection);
    }
}
