using UnityEngine;

public class CharacterMovement : MonoBehaviour
{
    [Header("Component references")]
    [SerializeField] private Rigidbody _rb;

    [Header("Movement settings")]
    [SerializeField] private float _movementSpeed = 3f;
    [SerializeField] private float _turnSpeed = 0.1f;

    [Header("Gravity settings")]
    [SerializeField] private float _gravity = -9.8f;
    [SerializeField] private float _groundedGravity = -0.2f;
    [SerializeField] private float _groundCheckDistance = .2f;
    [SerializeField] private LayerMask _groundMask;
    bool _isGrounded;

    //Stored values
    private Vector3 _movementDirection;
    private Quaternion _currentOrientation;
    private Vector3 _lookAtDirection;

    //Getter
    public Rigidbody RB { get { return _rb; } }

    private void Start()
    {
        _currentOrientation = Quaternion.identity;
        _lookAtDirection = Vector3.forward;

        _rb.useGravity = false;
    }
    public void UpdateMovementData(Vector3 newMovementDirection)
    {
        _movementDirection = newMovementDirection;
    }

    public void UpdateLookAtData(Vector3 newLookDirection)
    {
        if (newLookDirection.sqrMagnitude > 0.01f)
        {
            _lookAtDirection = newLookDirection;
        }
        else _lookAtDirection = _movementDirection;
    }

    void FixedUpdate()
    {
        MoveThePlayer();
        TurnThePlayer();
        HandleGravity();
    }
    void HandleGravity()
    {
        _isGrounded = Physics.Raycast(transform.position, Vector3.down, _groundCheckDistance, _groundMask);

        float gravityForce = _isGrounded ? _groundedGravity : _gravity;

        Vector3 velocity = _rb.linearVelocity;
        velocity.y += gravityForce + Time.deltaTime;
        _rb.linearVelocity = velocity;
    }

    void MoveThePlayer()
    {
        Vector3 movement = WorldDirection(_movementDirection);
        Vector3 velocity = _rb.linearVelocity;
        velocity.x = movement.x * _movementSpeed;
        velocity.z = movement.z * _movementSpeed;

        _rb.linearVelocity = velocity;
    }

    void TurnThePlayer()
    {
        if (_lookAtDirection.sqrMagnitude > 0.01f)
        {
            Quaternion targetRotation = Quaternion.LookRotation(_lookAtDirection);

            Quaternion rotation = Quaternion.Slerp(_currentOrientation, targetRotation, _turnSpeed);
            _rb.MoveRotation(rotation);
            _currentOrientation = rotation;
        }
    }
    Vector3 WorldDirection(Vector3 movementDirection)
    {
        var worldForward = Vector3.forward;
        var worldRight = Vector3.right;

        worldForward.y = 0f;
        worldRight.y = 0f;

        return worldForward * movementDirection.z + worldRight * movementDirection.x;
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = _isGrounded ? Color.green : Color.red;
        Gizmos.DrawLine(transform.position, transform.position + Vector3.down * _groundCheckDistance);
    }
}
