using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BasicProjectile : ItemBase
{
    public float speed = 20f;
    [SerializeField] private Rigidbody rb;
    [SerializeField] public int NumOfBounces = 3;

    private Vector3 lastVelocity;
    private float curSpeed;
    private Vector3 direction;
    private int curBounces = 0;

    void OnEnable()
    {
        direction = TankShooting.instance.TurretSpawner.transform.forward;
    }
    private void Start()
    {
        curBounces = 0;
        rb = GetComponent<Rigidbody>();
    }

    private void OnDisable()
    {
        rb.linearVelocity = Vector3.zero;
    }

    private void LateUpdate()
    {
        lastVelocity = rb.linearVelocity;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.layer == 8)
        {
            Bounce(collision);
        }
    }
    public void Bounce(Collision collision)
    {
        if (curBounces >= NumOfBounces)
        {
            ItemBase.instance.returnItem();
        }


        curSpeed = lastVelocity.magnitude;
        direction = Vector3.Reflect(lastVelocity.normalized, collision.contacts[0].normal);

        rb.linearVelocity = direction * Mathf.Max(curSpeed, 0);

        curBounces++;
    }
}