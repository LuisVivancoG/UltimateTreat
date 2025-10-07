using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Missile : PooledAsset
{
    [SerializeField] private float _damageDeal;
    [SerializeField] private Rigidbody _rb;

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.TryGetComponent<HealthSystem>(out var targetHealth))
        {
            targetHealth.TakeDamage(_damageDeal);
        }

        _rb.linearVelocity = Vector3.zero;
        _rb.angularVelocity = Vector3.zero;
        returnItem();
    }
}
