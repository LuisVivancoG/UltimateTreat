using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    [Header("Player ID")]
    private int _playerID;

    [Header("Sub Behaviours")]
    [SerializeField] private CharacterMovement _movementBehaviour;
    [SerializeField] private CharacterShooting _shootingBehaviour;
    //public PlayerAnimationBehaviour _playerAnimationBehaviour;
    //public PlayerVisualsBehaviour _playerVisualsBehaviour;


    [Header("Input settings")]
    [SerializeField] private float _movementSmoothSpeed = 1f;
    private PlayerInput _playerInput;
    private Vector3 _rawInputMovement;
    private Vector3 _smoothInputMovement;
    private Vector3 _lookAtInput;

    private string _actionMapPlayerControls = "Player Controls";
    private string _actionMapMenuControls = "Menu Controls";
    private string _currentControlScheme;

    public void SetUpPlayer (int currentPlayerID)
    {
        _playerID = currentPlayerID;

        //_currentControlScheme = _playerInput.currentControlScheme;

        //_movementBehaviour.SetupBehaviour();
        //_playerAnimationBehaviour.SetupBehaviour();
        //_playerVisualsBehaviour.SetupBehaviour(_playerID, _playerInput);
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
            Debug.Log("Bang!");
            //_playerAnimationBehaviour.PlayAttackAnimation();
            _shootingBehaviour.Fire();
        }
    }

    public void OnTogglePause(InputAction.CallbackContext value)
    {
        if (value.started)
        {
            Debug.Log("Game paused");
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
