using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;
using UnityEngine.UI;

public class MESManager : MonoBehaviour
{
    [SerializeField] private MultiplayerEventSystem _playerEventS;
    [SerializeField] private GameObject _displayPrefab;

    [Header ("Color display")]
    [SerializeField] private PlayerInput _inputs;
    [SerializeField] private CharacterVisualsBehaviour _playerVisuals;
    [SerializeField] private PlayerController _controller;

    public Color ColorAssigned {  get; private set; }
    public PlayerInput PlayerInput { get { return _inputs; } }

    private DisplayColorManager _colorManager;
    private PlayerDisplay _display;
    private int _currentColor;

    private MenuFlows _inputManager;

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);

        _inputManager = FindAnyObjectByType<MenuFlows>();

        _currentColor = 0;
    }

    private void Start()
    {
        _colorManager = FindAnyObjectByType<DisplayColorManager>();

        StartCoroutine(FirstSelectionDelay());
        var ui = Instantiate(_displayPrefab, _inputManager.DisplayGrp.transform);
        ui.TryGetComponent<PlayerDisplay>(out var component);
        component.NewDisplay();
        _display = component;
        _display.DisplayedSprite.color = _colorManager.LookForColor(0);

        ApplyNewColor(_colorManager.LookForColor(0));

        _inputManager.AddPlayerToList(this);

        _controller.SetEventHandler(this);
    }

    public void RightTrigger(InputAction.CallbackContext value)
    {
        if(value.performed)
        {
            AddIndexColor();
        }
    }
    public void LeftTrigger(InputAction.CallbackContext value)
    {
        if (value.performed)
        {
            DecreaseIndexColor();
        }
    }

    public void AddIndexColor()
    {
        _currentColor += 1;
        if (_currentColor > _colorManager.ColorsAvailable.ColorsDictionary.Count)
        {
            _currentColor = 0;
            ApplyNewColor(_colorManager.LookForColor(_currentColor));
        }
        else
        {
            ApplyNewColor(_colorManager.LookForColor(_currentColor));
        }
    }
    public void DecreaseIndexColor()
    {
        _currentColor -= 1;
        if (_currentColor < 0)
        {
            _currentColor = _colorManager.ColorsAvailable.ColorsDictionary.Count;
            ApplyNewColor(_colorManager.LookForColor(_currentColor));
        }
        else
        {
            ApplyNewColor(_colorManager.LookForColor(_currentColor));
        }
    }

    void ApplyNewColor(Color current)
    {
        _display.DisplayedSprite.color = current;
        _playerVisuals.SetColor(current);
        ColorAssigned = current;
    }

    public void UpdateCurrentSelection(GameObject current)
    {
        StartCoroutine(DelayNewSelection(current));
    }

    IEnumerator DelayNewSelection(GameObject selection)
    {
        yield return new WaitForSeconds(.3f);
        _playerEventS.SetSelectedGameObject(selection);
    }

    IEnumerator FirstSelectionDelay()
    {
        yield return new WaitForSeconds(1);
        _playerEventS.SetSelectedGameObject(_inputManager.InitialSelection);
        _playerEventS.playerRoot = _inputManager.gameObject;
    }
}
