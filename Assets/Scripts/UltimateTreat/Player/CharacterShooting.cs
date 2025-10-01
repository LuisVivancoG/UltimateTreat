using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;

public class CharacterShooting : MonoBehaviour
{
    /*
    [SerializeField] private ParticleSystem _shootingSystem;
    [SerializeField] private Transform _spawnerLoc;
    [SerializeField] private ParticleSystem _impactParticleSystem;
    [SerializeField] private TrailRenderer _bulletTrail;
    [SerializeField] private float _shootDelay = 0.175f;
    [SerializeField] private float _speed = 100;
    [SerializeField] private LayerMask _mask;
    [SerializeField] private bool _bouncingBullets;
    [SerializeField] private float _bounceDistance = 10f;

    private float _lastShootTime;
    public Transform SpawnerLoc => _spawnerLoc;

    public void Fire()
    {
        if (_lastShootTime + _shootDelay < Time.time)
        {
            // Use an object pool instead for these! To keep this tutorial focused, we'll skip implementing one.
            // for more details you can see: https://youtu.be/fsDE_mO4RZM or if using Unity 2021+: https://youtu.be/zyzqA_CPz2E

            _shootingSystem.Play();

            Vector3 direction = transform.forward;
            var trail = PoolsManagment.Instance.GetObject(SOType.BulletTrail, SpawnerLoc.position, SpawnerLoc.localEulerAngles);
            //TrailRenderer trail = Instantiate(_bulletTrail, SpawnerLoc.position, Quaternion.identity);

            if(trail.TryGetComponent<TrailRenderer>(out var component))
            {

                if (Physics.Raycast(_spawnerLoc.position, direction, out RaycastHit hit, float.MaxValue, _mask))
                {
                    Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * hit.distance, Color.yellow);

                    StartCoroutine(SpawnTrail(component, hit.point, hit.normal, _bounceDistance, true));
                    if(hit.transform.TryGetComponent<HealthSystem>(out var targetHealth))
                    {
                        Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * hit.distance, Color.red);

                        targetHealth.TakeDamage(50f);
                    }
                }
                else
                {
                    StartCoroutine(SpawnTrail(component, SpawnerLoc.position + direction * 100, Vector3.zero, _bounceDistance, false));
                }
            }

            _lastShootTime = Time.time;
        }
    }

    private IEnumerator SpawnTrail(TrailRenderer Trail, Vector3 HitPoint, Vector3 HitNormal, float BounceDistance, bool MadeImpact)
    {
        Vector3 startPosition = Trail.transform.position;
        Vector3 direction = (HitPoint - Trail.transform.position).normalized;

        float distance = Vector3.Distance(Trail.transform.position, HitPoint);
        float startingDistance = distance;

        while (distance > 0)
        {
            Trail.transform.position = Vector3.Lerp(startPosition, HitPoint, 1 - (distance / startingDistance));
            distance -= Time.deltaTime * _speed;

            yield return null;
        }

        Trail.transform.position = HitPoint;

        if (MadeImpact)
        {
            _impactParticleSystem.transform.LookAt(HitNormal);
            _impactParticleSystem.transform.position = HitPoint;
            _impactParticleSystem.Play();
            //Instantiate(_impactParticleSystem, HitPoint, Quaternion.LookRotation(HitNormal));


            if (_bouncingBullets && BounceDistance > 0)
            {
                Vector3 bounceDirection = Vector3.Reflect(direction, HitNormal);

                if (Physics.Raycast(HitPoint, bounceDirection, out RaycastHit hit, BounceDistance, _mask))
                {
                    yield return StartCoroutine(SpawnTrail(
                        Trail,
                        hit.point,
                        hit.normal,
                        BounceDistance - Vector3.Distance(hit.point, HitPoint),
                        true
                    ));
                }
                else
                {
                    yield return StartCoroutine(SpawnTrail(
                        Trail,
                        HitPoint + bounceDirection * BounceDistance,
                        Vector3.zero,
                        0,
                        false
                    ));
                }
            }
        }
        Trail.transform.TryGetComponent<PooledAsset>(out var component);
        component.returnItem();
        //Destroy(Trail.gameObject, Trail.time);
    }*/
    [SerializeField] private Transform _spawnerLoc;
    [SerializeField] private float _forceSpeed = 100f;
    [SerializeField] private float _fireCd = 3f;
    private bool _canShoot = true;
    public SOType _currentPower = SOType.BasicProjectile;

    public Transform SpawnerLoc => _spawnerLoc;

    public void Fire()
    {
        if (_canShoot)
        {
            _canShoot = false;
            var projectile = PoolsManagment.Instance.GetObject(SOType.BasicProjectile, SpawnerLoc);
            projectile.TryGetComponent<Rigidbody>(out Rigidbody rb);
            rb.linearVelocity = SpawnerLoc.forward * _forceSpeed;
            StartCoroutine(FireCooldown());
        }
    }

    private IEnumerator FireCooldown()
    {
        yield return new WaitForSeconds(_fireCd);
        _canShoot = true;
    }
}
