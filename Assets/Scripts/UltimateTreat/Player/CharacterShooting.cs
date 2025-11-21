using System;
using System.Collections;
using UnityEngine;

public class CharacterShooting : MonoBehaviour
{
    [SerializeField] private Transform _spawnerLoc;
    private bool _canShoot = true;
    public SOType _currentProjectile = SOType.BasicProjectile;
    public SOType _queueHability = SOType.None;

    public Transform SpawnerLoc => _spawnerLoc;

    [NonSerialized] public bool HasItem;
    private CharacterVisualsBehaviour _visuals;
    private Rigidbody _characterRb;
    private Coroutine _fireCadence;
    private CapsuleCollider _playerCollider;
    private HealthSystem _health;
    private int _specialProjectilesUsed;

    public void SetBehaviours(CharacterVisualsBehaviour current, HealthSystem playerHealth, Rigidbody body)
    {
        _visuals = current;
        _characterRb = body;
        _health = playerHealth;

        _playerCollider = GetComponent<CapsuleCollider>();
    }

    public void Fire()
    {
        if (_canShoot)
        {
            _visuals.PlayMuzzleParticles(_spawnerLoc.position, transform.localEulerAngles);
            _canShoot = false;
            var projectile = PoolsManagment.Instance.GetObject(_currentProjectile, SpawnerLoc.position, transform.localEulerAngles);

            SoundManager.Instance.Play("Gun");
            projectile.TryGetComponent<ProjectileBase>(out ProjectileBase component);
            component.SetIgnoreCollider(_playerCollider);
            var velocity = SpawnerLoc.forward * component.SpeedForce;
            velocity.y = component.Gravity;
            component.RB.linearVelocity = velocity;

            _fireCadence = StartCoroutine(FireCooldown(component.FireCD));

            _characterRb.AddForce((transform.forward * -component.Recoil), ForceMode.Impulse);

            if(_currentProjectile != SOType.BasicProjectile)
            {
                _currentProjectile = SOType.BasicProjectile;
                _queueHability = SOType.None;
                HasItem = false;
            }
            //_specialProjectilesUsed++;
            //CameraShakeManager.Instance.AddShake(.05f, .15f, .1f);
        }
    }

    private IEnumerator FireCooldown(float timer)
    {
        yield return new WaitForSeconds(timer);
        _canShoot = true;
    }

    public void EnableingPower()
    {
        _currentProjectile = _queueHability;
    }

    IEnumerator PukeChocolate()
    {
        StopCoroutine(_fireCadence);
        _canShoot = false;

        StartCoroutine(FireCooldown(5f));

        while (!_canShoot)
        {
            yield return StartCoroutine(ShootFountain());
        }
        HasItem = false;
    }

    void SwitchProjectiles(SOType newProjectile)
    {
        _currentProjectile = newProjectile;

    }

    IEnumerator ShootFountain()
    {
        var randomX = UnityEngine.Random.Range(-20, 0);
        var randomY = UnityEngine.Random.Range(-30, 30);
        Vector3 rotOffset = new Vector3(randomX, randomY, 0);
        SpawnerLoc.localEulerAngles = rotOffset;

        var projectile = PoolsManagment.Instance.GetObject(SOType.ChocoProjectile, SpawnerLoc.position, transform.localEulerAngles);

        projectile.TryGetComponent<ProjectileBase>(out ProjectileBase component);
        component.SetIgnoreCollider(_playerCollider);
        var velocity = SpawnerLoc.forward * component.SpeedForce;
        velocity.y = component.Gravity;
        component.RB.linearVelocity = velocity;

        yield return new WaitForSeconds(.075f);
        SpawnerLoc.localEulerAngles = Vector3.zero;
    }

    public void ActivateItem()
    {
        if (HasItem)
        {
            switch (_queueHability)
            {
                case SOType.ChocoProjectile:
                    StartCoroutine(PukeChocolate());
                    break;
                case SOType.RollerProjectile:
                    _currentProjectile = SOType.RollerProjectile;
                    break;
                case SOType.HealPack:
                    Debug.Log($"Current health {_health.CurrentHealthPoints}");
                    _health.Heal(20);
                    Debug.Log($"Health after item {_health.CurrentHealthPoints}");
                    HasItem = false;
                    break;

            }

            Debug.LogWarning($"{_queueHability} used");
            //_hasItem = false;
        }
    }
}
