using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

public class TankShooting : MonoBehaviour
{
    [SerializeField] private GameObject _turretGrp;
    [SerializeField] private float _rotationSpeed;
    [SerializeField] private Transform _missileSpanwer;
    [SerializeField] private InputActionReference _fireInput;
    [SerializeField] private ItemData _defaultProjectile;
    [SerializeField] private HealthManager _playerHealth;

    public static TankShooting instance;

    public Transform TurretSpawner => _missileSpanwer;

    public UnityEvent<Sprite> ItemAdded;
    public UnityEvent ItemGone;

    private ItemData _currentProjectil;
    private float _horizontalInput;
    private float _fireCooldown;
    private float _launchForce;
    private float _abilityCountdown;
    private bool _hasSpecialProjectile;
    private bool _isFiring = false;
    public bool _hasPowerUp { get; private set; }
    public ItemBase _ability { get; private set; }
    public PoolsManager _poolManager { get; private set; }

    private void Awake()
    {
        instance = this;
    }

    private void OnEnable()
    {
        _currentProjectil = _defaultProjectile;
        _fireCooldown = _defaultProjectile.ReuseCooldown;
        _launchForce = _defaultProjectile.Speed;
        _abilityCountdown = _defaultProjectile.TimeBeforeConsume;
    }
    private void OnDisable()
    {
        _isFiring = false;
        _hasPowerUp = false;
        _ability = null;
        _hasSpecialProjectile = false;
        _currentProjectil = _defaultProjectile;
        StopAllCoroutines();
    }

    private void Update()
    {
        _turretGrp.transform.Rotate(0, _horizontalInput * _rotationSpeed, 0);
    }

    public void OnRotationTurret(InputAction.CallbackContext value) //gets input and assigns with declared variables
    {
        Vector2 inputMovement = value.ReadValue<Vector2>();
        _horizontalInput = inputMovement.x;
    }

    public void Attack(InputAction.CallbackContext value)
    {

        if (!_isFiring)
        {
            Fire();
            if(_hasSpecialProjectile)
            {
                _fireCooldown = 10f;
                _hasSpecialProjectile = false;
                RestoreStats();
            }
        }
    }
    private void Fire()
    {
        _isFiring = true;
        var i = _poolManager.GetItem(_currentProjectil, this);
        var rbi = i.GetComponent<Rigidbody>();
        rbi.linearVelocity = TurretSpawner.transform.forward * _launchForce;
        StartCoroutine(FireCooldown());
        AudioManager.PlaySound(TypeOfSound.Cannon);
    }
    public void SetAbility(ItemData newAbility)
    {
        AudioManager.PlaySound(TypeOfSound.ToolBox);
        ItemAdded?.Invoke(newAbility.ItemSprite);
        _hasPowerUp = true;
        StartCoroutine(AbilityTimeLeft(newAbility.TimeBeforeConsume));
        _ability = newAbility.ItemPrefab;
        if (newAbility.IsProjectile)
        {
            _currentProjectil = newAbility;
            _launchForce = newAbility.Speed;
            if (newAbility.IsSingleUse)
            {
                _hasSpecialProjectile = true;
            }
            else
            {
                _fireCooldown = newAbility.ReuseCooldown;
            }
        }
        if (!newAbility.IsProjectile)
        {
            _playerHealth.Heal(newAbility.HPModifier);
            AudioManager.PlaySound(TypeOfSound.Heal);
        }
    }

    IEnumerator AbilityTimeLeft(float countdown)
    {
        yield return new WaitForSeconds(countdown);
        RestoreStats();
    }
    IEnumerator FireCooldown()
    {
        yield return new WaitForSeconds(_fireCooldown);
        _isFiring = false;
    }
    private void RestoreStats()
    {
        ItemGone?.Invoke();
        _hasPowerUp = false;
        _currentProjectil = _defaultProjectile;
        _launchForce = _defaultProjectile.Speed;
        _fireCooldown = _defaultProjectile.ReuseCooldown;
        _abilityCountdown = _defaultProjectile.TimeBeforeConsume;
    }
    public void SetUp(PoolsManager main, HealthManager player)
    {
        _poolManager = main;
        _playerHealth = player;
    }
}
