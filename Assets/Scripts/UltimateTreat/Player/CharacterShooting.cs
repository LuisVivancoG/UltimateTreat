using System.Collections;
using UnityEngine;

public class CharacterShooting : MonoBehaviour
{
    [SerializeField] private Transform _spawnerLoc;
    [SerializeField] private float _baseForce = 100f;
    [SerializeField] private float _fireCd = 3f;
    [SerializeField] private float _recoilForce;
    private bool _canShoot = true;
    public SOType _currentPower = SOType.BasicProjectile;

    public Transform SpawnerLoc => _spawnerLoc;

    private bool _hasItem;
    private bool _itemUsed;
    private CharacterVisualsBehaviour _visuals;
    private Rigidbody _characterRb;

    public void SetBehaviours(CharacterVisualsBehaviour current, Rigidbody body)
    {
        _visuals = current;
        _characterRb = body;
    }

    public void Fire()
    {
        if (_canShoot)
        {
            _visuals.PlayMuzzleParticles(_spawnerLoc.position, transform.localEulerAngles);
            _canShoot = false;
            var projectile = PoolsManagment.Instance.GetObject(SOType.BasicProjectile, SpawnerLoc.position, transform.localEulerAngles);
            projectile.TryGetComponent<Rigidbody>(out Rigidbody rb);
            rb.linearVelocity = SpawnerLoc.forward * _baseForce;
            StartCoroutine(FireCooldown());

            _characterRb.AddForce((transform.forward * -_recoilForce), ForceMode.Impulse);
            //CameraShakeManager.Instance.AddShake(.05f, .15f, .1f);
        }
    }

    private IEnumerator FireCooldown()
    {
        yield return new WaitForSeconds(_fireCd);
        _canShoot = true;
    }

    public void ActivateItem()
    {
        if (_hasItem)
        {
            float initialForce = _baseForce;

            _baseForce = _baseForce * 2.5f;
        }
    }
}
