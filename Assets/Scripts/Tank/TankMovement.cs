using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class TankMovement : MonoBehaviour
{
    [SerializeField] private float _movementSpeed;
    [SerializeField] private float _rotationSpeed;
    [SerializeField] private Rigidbody _rigidbody;
    private float _horizontalInput;
    private float _verticalInput;

    private void OnEnable()
    {
        _rigidbody.isKinematic = false;
    }

    private void OnDisable()
    {
        _rigidbody.isKinematic = true;
    }

    private void Update()
    {
        CalculateMovement();
        CalculateTurn();
    }

    private void CalculateMovement() //process input and multiply with movSpeed
    {
        Vector3 movement = transform.forward * _verticalInput * _movementSpeed; //* Time.deltaTime;
        // _rigidbody.MovePosition(_rigidbody.position + movement);
        _rigidbody.linearVelocity = movement;
    }

    public void OnMovement(InputAction.CallbackContext value) //gets input and assigns with declared variables
    {
        Vector2 inputMovement = value.ReadValue<Vector2>();
        _horizontalInput = inputMovement.x;
        _verticalInput = inputMovement.y;
    }
    public void CalculateTurn() //process input and multiply with rotSpeed
    {
        float turn = _horizontalInput * _rotationSpeed * Time.deltaTime;
        Quaternion turnRotation = Quaternion.Euler(0, turn, 0);
        _rigidbody.MoveRotation(_rigidbody.rotation * turnRotation);
    }
}
