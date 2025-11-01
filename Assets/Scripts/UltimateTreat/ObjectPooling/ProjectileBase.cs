using System.Collections;
using UnityEngine;

[RequireComponent (typeof(Rigidbody))]

public class ProjectileBase : PooledAsset
{
    [SerializeField] private float _damageDeal;
    [SerializeField] private Rigidbody _rb;
    [SerializeField] private ParticleSystem _hitParticles;
    [SerializeField] private GameObject _decal;
    private MeshRenderer _projectileMesh;
    private float _particlesDuration;

    private void Awake()
    {
        _projectileMesh = GetComponent<MeshRenderer>();
        _particlesDuration = _hitParticles.main.duration;
    }

    private void OnEnable()
    {
        _projectileMesh.enabled = true;
        _rb.isKinematic = false;
    }

    private void OnCollisionEnter(Collision collision)
    {
        var contactPoint = collision.GetContact(0).point;
        var contactNormal = collision.GetContact(0).normal;
        Instantiate(_decal, contactPoint, Quaternion.identity);

        /*var positionContact = collision.contacts[0];
        _hitParticles.transform.position = positionContact.point;
        _hitParticles.transform.localEulerAngles = positionContact.normal;*/
        _hitParticles.Play();
        //PoolsManagment.Instance.GetObject(SOType.HitParticles, positionContact.point, transform.localEulerAngles);

        if (collision.transform.TryGetComponent<HealthSystem>(out var targetHealth))
        {
            targetHealth.TakeDamage(_damageDeal);
            if(collision.transform.TryGetComponent<Rigidbody>(out var body))
            {
                body.AddForce(contactPoint.normalized * 30f, ForceMode.Impulse);
            }
        }

        _rb.linearVelocity = Vector3.zero;
        _rb.angularVelocity = Vector3.zero;
        _rb.isKinematic = true;
        _projectileMesh.enabled = false;
        StartCoroutine(Countdown());
    }

    IEnumerator Countdown()
    {
        yield return new WaitForSeconds(_particlesDuration);
        returnItem();
    }
}
