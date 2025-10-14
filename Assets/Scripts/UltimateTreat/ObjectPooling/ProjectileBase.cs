using UnityEngine;

[RequireComponent (typeof(Rigidbody))]

public class ProjectileBase : PooledAsset
{
    [SerializeField] private float _damageDeal;
    [SerializeField] private Rigidbody _rb;

    private void OnCollisionEnter(Collision collision)
    {
        var positionContact = collision.contacts[0];
        PoolsManagment.Instance.GetObject(SOType.HitParticles, positionContact.point, transform.localEulerAngles);

        if (collision.transform.TryGetComponent<HealthSystem>(out var targetHealth))
        {
            targetHealth.TakeDamage(_damageDeal);
        }

        _rb.linearVelocity = Vector3.zero;
        _rb.angularVelocity = Vector3.zero;
        returnItem();
    }
}
