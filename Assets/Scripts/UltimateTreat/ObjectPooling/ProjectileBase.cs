using DG.Tweening;
using System.Collections;
using UnityEngine;

[RequireComponent (typeof(Rigidbody))]

public class ProjectileBase : PooledAsset
{
    //Common properties projectiles
    [SerializeField] private float _damageDeal;
    [SerializeField] private Rigidbody _rb;
    [SerializeField] private float _gravityForce;
    [SerializeField] private SOType _impactParticles = SOType.BasicProjectileImpact;
    [SerializeField] private float _speedForce = 30f;
    [SerializeField] private float _fireCD = 0.7f;
    [SerializeField] private float _recoil = 10f;

    private Collider _ignoredCollider;

    public SphereCollider BulletCollider { get; private set; }
    public float SpeedForce { get { return _speedForce; } }
    public float FireCD { get { return _fireCD; } }
    public float Recoil { get { return _recoil; } }
    public Rigidbody RB { get { return _rb; } }
    public float Gravity { get { return _gravityForce; } }

    private void Awake()
    {
        Vector3 velocity = _rb.linearVelocity;
        velocity.y += _gravityForce + Time.deltaTime;
        _rb.linearVelocity = velocity;
        BulletCollider = GetComponent<SphereCollider>();
    }

    private void OnEnable()
    {
        SetProjectile();
    }

    public void SetIgnoreCollider(Collider parent)
    {
        _ignoredCollider = parent;
        Debug.Log(parent.gameObject);

        Physics.IgnoreCollision(BulletCollider, _ignoredCollider, true);
    }

    internal virtual void SetProjectile()
    {
        _rb.isKinematic = false;
    }


    private void OnCollisionEnter(Collision collision)
    {
        var contactPoint = collision.GetContact(0).point;
        var contactNormal = collision.GetContact(0).normal;

        ProcessEffects(contactPoint, contactNormal);

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

        Physics.IgnoreCollision(BulletCollider, _ignoredCollider, false);

        returnItem();
    }

    internal virtual void ProcessEffects(Vector3 contactP, Vector3 contactN)
    {
        PoolsManagment.Instance.GetObject(_impactParticles, contactP, contactN);
    }
}
