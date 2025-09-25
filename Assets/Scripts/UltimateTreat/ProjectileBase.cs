using UnityEngine;

[RequireComponent (typeof(Rigidbody))]

public class ProjectileBase : PooledAsset
{
    private Rigidbody _rb;

    private void Start()
    {
        _rb = GetComponent<Rigidbody>();
    }


    private void OnEnable()
    {
        //_rb.linearVelocity = Vector3.zero;
        //_rb.linearVelocity;
    }

    private void OnCollisionEnter(Collision collision)
    {
        returnItem();
    }
}
