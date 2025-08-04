package springmvcsearch;

import java.util.*;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;



@Controller
public class LlamaSearchController {

    @Autowired
    private LlamaGptService llamachatGptService;

    @RequestMapping("/homeLlama")
    public String home(HttpSession session, Model model) {
        if (session.getAttribute("chatHistory") == null) {
            session.setAttribute("chatHistory", new ArrayList<ChatMessage>());
        }
        model.addAttribute("chatHistory", session.getAttribute("chatHistory"));
        return "homeLlama";
    }

    /*@RequestMapping("/send")
    public String sendMessage(@RequestParam("querybox") String query, HttpSession session, Model model) {
        @SuppressWarnings("unchecked")
        List<ChatMessage> chatHistory = (List<ChatMessage>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        if (query != null && !query.trim().isEmpty()) {
            chatHistory.add(new ChatMessage("user", query));
            String answer = chatGptService.getOpenRouterResponse(query);
            chatHistory.add(new ChatMessage("bot", answer));
        }

        session.setAttribute("chatHistory", chatHistory);
        model.addAttribute("chatHistory", chatHistory);

        return "homeLlama";
    }*/
	/*
	 * @RequestMapping("/send") public String sendMessage(@RequestParam("querybox")
	 * String query, HttpSession session, Model model) {
	 * 
	 * @SuppressWarnings("unchecked") List<ChatMessage> sessionHistory =
	 * (List<ChatMessage>) session.getAttribute("chatHistory"); if (sessionHistory
	 * == null) { sessionHistory = new ArrayList<>(); }
	 * 
	 * // Make a *separate copy* to work on List<ChatMessage> chatHistory = new
	 * ArrayList<>(sessionHistory);
	 * 
	 * if (query != null && !query.trim().isEmpty()) { chatHistory.add(new
	 * ChatMessage("user", query)); String answer =
	 * chatGptService.getOpenRouterResponse(query); chatHistory.add(new
	 * ChatMessage("bot", answer)); }
	 * 
	 * // Replace session attribute with the *new* list
	 * session.setAttribute("chatHistory", chatHistory);
	 * model.addAttribute("chatHistory", chatHistory);
	 * 
	 * return "homeLlama"; }
	 */
    @GetMapping("/send")
    public String sendMessage(
            @RequestParam("querybox") String query,
            HttpSession session,
            Model model
    ) {
        @SuppressWarnings("unchecked")
        List<ChatMessage> chatHistory = (List<ChatMessage>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        if (query != null && !query.trim().isEmpty()) {
            chatHistory.add(new ChatMessage("user", query));
            String answer = llamachatGptService.getOpenRouterResponse(query);
            chatHistory.add(new ChatMessage("bot", answer));
        }

        session.setAttribute("chatHistory", chatHistory);
        model.addAttribute("chatHistory", chatHistory);
        return "homeLlama";
    }

}