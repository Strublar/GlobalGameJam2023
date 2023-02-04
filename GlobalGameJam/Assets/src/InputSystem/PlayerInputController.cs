using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInputController : MonoBehaviour
{
    private PlayerControls player;

    public void Awake()
    {
        player = new PlayerControls();
        player.Player.Enable();
        player.Player.ToggleMainMenu.performed += toggleMainMenu;
    }

    private void toggleMainMenu(InputAction.CallbackContext context)
    {
        GameManager.instance.ToggleMainMenu();
    }
}