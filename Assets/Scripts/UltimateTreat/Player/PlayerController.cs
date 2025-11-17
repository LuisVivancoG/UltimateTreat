using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;

public class PlayerController : MonoBehaviour
{
    [Header("Player ID")]
    [SerializeField] private GameObject _characterGO;
    private int _playerID;

    [Header("Sub Behaviours")]
    [SerializeField] private CharacterMovement _movementBehaviour;
    [SerializeField] private CharacterShooting _shootingBehaviour;
    [SerializeField] private CharacterVisualsBehaviour _visualsBehaviour;
    [SerializeField] private HealthSystem _playerHealth;
    //public PlayerAnimationBehaviour _playerAnimationBehaviour;

    [Header("Input settings")]
    [SerializeField] private float _movementSmoothSpeed = 1f;
    [SerializeField] private PlayerInput _playerInput;
    
    private float _maxHP;
    private Vector3 _rawInputMovement;
    private Vector3 _smoothInputMovement;
    private Vector3 _lookAtInput;

    private string _actionMapPlayerControls = "Player Controls";
    private string _actionMapMenuControls = "Menu Controls";
    private string _currentControlScheme;

    private MESManager _mESManager;

    public GameObject CharacterGO { get { return _characterGO; } }
    public Color PlayerColor => _visualsBehaviour.PickedColor;

    public void SetUp(int currentPlayerID, float hP)
    {
        _playerID = currentPlayerID;
        _maxHP = hP;
        _playerHealth.SetHP(_maxHP);
        _currentControlScheme = _playerInput.currentControlScheme;

        //_movementBehaviour.SetupBehaviour();
        //_playerAnimationBehaviour.SetupBehaviour();
        //_playerVisualsBehaviour.SetupBehaviour(_playerID, _playerInput);
        _shootingBehaviour.SetBehaviours(_visualsBehaviour, _playerHealth, _movementBehaviour.RB);
        _visualsBehaviour.EnableGeo();
    }
    public void SetEventHandler(MESManager currentMES)
    {
        _mESManager = currentMES;
    }
    public void RestoreStats()
    {
        _playerHealth.SetHP(_maxHP);
        _visualsBehaviour.ResetColor();
    }
    public void OnMovement(InputAction.CallbackContext value)
    {
        Vector2 inputMovement = value.ReadValue<Vector2>();
        _rawInputMovement = new Vector3(inputMovement.x, 0, inputMovement.y);
    }

    public void OnAiming(InputAction.CallbackContext value)
    {
        Vector2 inputAim = value.ReadValue<Vector2>();
        _lookAtInput = new Vector3(inputAim.x, 0, inputAim.y);
    }
    public void OnAttack(InputAction.CallbackContext value)
    {
        if (value.started)
        {
            //Debug.Log("Bang!");
            //_playerAnimationBehaviour.PlayAttackAnimation();
            _shootingBehaviour.Fire();
        }
    }

    public void OnAbilityTriggered(InputAction.CallbackContext value)
    {
        if (value.started)
        {
            Debug.Log("Ability used");
            _shootingBehaviour.ActivateItem();
        }
    }

    public void OnTogglePause(InputAction.CallbackContext value)
    {
        if (value.started)
        {
            UIManager.Instance.ShowDialog(Menus.PauseMenu);
            _playerInput.SwitchCurrentActionMap("Menu Controls");

            var pauseMenu = FindAnyObjectByType<PauseDialog>();
            if (pauseMenu != null)
            {
                _mESManager.UpdateCurrentSelection(pauseMenu.FirstSelection);
            }
            /*else
            {
                var menu = UIManager.Instance.ShowDialog(Menus.PauseMenu);
                menu.TryGetComponent<PauseDialog>(out var component);
                _mESManager.UpdateCurrentSelection(component.FirstSelection);
            }*/
            //GameManager.Instance.TogglePauseState(this);
        }
    }
    public void OnControlsChanged()
    {

        if (_playerInput.currentControlScheme != _currentControlScheme)
        {
            _currentControlScheme = _playerInput.currentControlScheme;

            //_playerVisualsBehaviour.UpdatePlayerVisuals();
            RemoveAllBindingOverrides();
        }
    }
    public void OnDeviceLost()
    {
        //_playerVisualsBehaviour.SetDisconnectedDeviceVisuals();
    }
    public void OnDeviceRegained()
    {
        StartCoroutine(WaitForDeviceToBeRegained());
    }
    IEnumerator WaitForDeviceToBeRegained()
    {
        yield return new WaitForSeconds(0.1f);
        //playerVisualsBehaviour.UpdatePlayerVisuals();
    }
    private void Update()
    {
        CalculateMovementInputSmoothing();
        UpdatePlayerMovement();
        //UpdatePlayerAnimationMovement();
    }
    void CalculateMovementInputSmoothing()
    {
        _smoothInputMovement = Vector3.Lerp(_smoothInputMovement, _rawInputMovement, Time.deltaTime * _movementSmoothSpeed);
    }
    void UpdatePlayerMovement()
    {
        _movementBehaviour.UpdateMovementData(_smoothInputMovement);
        if (_lookAtInput.sqrMagnitude > 0.01f)
        {
            _movementBehaviour.UpdateLookAtData(_lookAtInput);
        }
        else
        {
            _movementBehaviour.UpdateLookAtData(Vector3.zero); // No aiming input, use movement-based rotation
        }
    }
    /*void UpdatePlayerAnimationMovement()
    {
        _playerAnimationBehaviour.UpdateMovementAnimation(_smoothInputMovement.magnitude);
    }*/
    public void SetInputActiveState(bool gameIsPaused)
    {
        switch (gameIsPaused)
        {
            case true:
                _playerInput.DeactivateInput();
                break;

            case false:
                _playerInput.ActivateInput();
                break;
        }
    }
    void RemoveAllBindingOverrides()
    {
        InputActionRebindingExtensions.RemoveAllBindingOverrides(_playerInput.currentActionMap);
    }
    public void EnableGameplayControls()
    {
        _playerInput.SwitchCurrentActionMap(_actionMapPlayerControls);
    }
    public void EnablePauseMenuControls()
    {
        _playerInput.SwitchCurrentActionMap(_actionMapMenuControls);
    }
    public int GetPlayerID()
    {
        return _playerID;
    }
    public InputActionAsset GetActionAsset()
    {
        return _playerInput.actions;
    }
    public PlayerInput GetPlayerInput()
    {
        return _playerInput;
    }
}
