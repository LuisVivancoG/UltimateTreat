using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogBase : MonoBehaviour
{
    public Canvas DialogCanvas;
    protected UIManager _manager;
    public virtual Menus MenuType()
    {
        return Menus.Underfined;
    }

    public void OnCreation(UIManager manager)
    {
        _manager = manager;
    }
}
