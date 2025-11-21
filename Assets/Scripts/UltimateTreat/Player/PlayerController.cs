using System.Collections;
using System.Collections.Generic;
using Unity.Cinemachine;
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
    [SerializeField] private Animator _anim;
    //public PlayerAnimationBehaviour _playerAnimationBehaviour;

    [Header("Input settings")]
    [SerializeField] private float _movementSmoothSpeed = 1f;
    [SerializeField] private PlayerInput _playerInput;

    [SerializeField] private LayerMask _decorationMask;
    [SerializeField] private CinemachineImpulseSource _impulseSource;
    
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
    public int PlayerID => _playerID;

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
        _anim.SetFloat("Velocity", inputMovement.sqrMagnitude);
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
            GameManager.Instance.TogglePause(_mESManager, this);

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
    public void ExplosionCast()
    {
        Debug.Log("Explosion called");
        float radius = 15f;
        List<CinemachineExternalImpulseListener> listenersHit = new List<CinemachineExternalImpulseListener>();

        Collider[] hits = Physics.OverlapSphere(_characterGO.transform.position, radius, _decorationMask);

        foreach (Collider hit in hits)
        {
            if (hit.TryGetComponent<CinemachineExternalImpulseListener>(out var listener))
            {
                listenersHit.Add(listener);

                float distance = Vector3.Distance(_characterGO.transform.position, hit.transform.position);
                listener.Gain = Mathf.Lerp(0, 1, distance/radius);
            }
        }
        _impulseSource.GenerateImpulseAt(_characterGO.transform.position, new Vector3(1, .5f, 0));

        StartCoroutine(RestoreGain(listenersHit));
    }

    IEnumerator RestoreGain(List<CinemachineExternalImpulseListener> list)
    {
        yield return new WaitForSeconds(1);
        foreach (var listener in list)
        {
            listener.Gain = 0;
        }
        list.Clear();
    }

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
    public InputActionAsset GetActionAsset()
    {
        return _playerInput.actions;
    }
    public PlayerInput GetPlayerInput()
    {
        return _playerInput;
    }
}
