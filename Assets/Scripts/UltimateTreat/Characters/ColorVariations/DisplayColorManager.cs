using UnityEngine;

public class DisplayColorManager : MonoBehaviour
{
    [SerializeField] private AllColorsPicker _colorsAvailable;
    public AllColorsPicker ColorsAvailable => _colorsAvailable;

    private void Start()
    {
        ColorsAvailable.SetColorsDictionary();
    }

    public Color LookForColor(int iD)
    {
        return ColorsAvailable.FetchColor(iD);
    }
}
