using UnityEngine;

[RequireComponent (typeof(Rigidbody))]

public class ProjectileBase : PooledAsset
{
    [SerializeField] private float _damageDeal;
    private Rigidbody _rb;

    private void Start()
    {
        _rb = GetComponent<Rigidbody>();
    }


    private void OnDisable()
    {
        _rb.linearVelocity = Vector3.zero;
        _rb.angularVelocity = Vector3.zero;
        //_rb.linearVelocity;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.transform.TryGetComponent<HealthSystem>(out var targetHealth))
        {
            targetHealth.TakeDamage(_damageDeal);
        }

        returnItem();
    }
}
