// Simple AI Q&A endpoint
// In production, replace with OpenAI / Gemini / Grok API call

// @desc    Ask AI anything (Student)
// @route   POST /api/ai/ask
// @access  Private/Student
exports.askAI = async (req, res) => {
  try {
    const { question } = req.body;

    if (!question || question.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a question',
      });
    }

    // Placeholder response - Replace this with real AI API
    // Example with OpenAI:
    /*
    const OpenAI = require('openai');
    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        { role: "system", content: "You are a helpful academic assistant for students." },
        { role: "user", content: question }
      ],
    });
    const answer = completion.choices[0].message.content;
    */

    // Demo intelligent responses based on keywords
    let answer = '';
    const q = question.toLowerCase();

    if (q.includes('attendance') || q.includes('present')) {
      answer =
        'To check your attendance, go to the Attendance section in your dashboard. You can view overall percentage and lecture-wise details. Maintain at least 75% attendance as per university rules.';
    } else if (q.includes('fee') || q.includes('payment')) {
      answer =
        'You can view your fee details and payment status in the Fees section. For any payment issues, contact the accounts department or your faculty advisor.';
    } else if (q.includes('result') || q.includes('marks') || q.includes('exam')) {
      answer =
        'Results are uploaded by faculty after exams. Check the Results section for your semester-wise performance, grades, and CGPA.';
    } else if (q.includes('timetable') || q.includes('schedule') || q.includes('class')) {
      answer =
        'Your class timetable is available in the Timetable section. It shows day-wise and period-wise schedule including room numbers.';
    } else if (q.includes('note') || q.includes('study material')) {
      answer =
        'Faculty uploads notes and study materials in the Notes section. You can filter by subject and download them.';
    } else if (q.includes('hello') || q.includes('hi') || q.includes('hey')) {
      answer =
        'Hello! I am Nexora AI Assistant. You can ask me anything about your academics, attendance, fees, results, timetable, or general study-related questions.';
    } else {
      answer = `Thank you for your question: "${question}"\n\nThis is a demo AI response. In production, this will be connected to a real AI model (OpenAI / Gemini / Grok) that can answer any academic question, explain concepts, help with assignments, and more.\n\nTo enable real AI:\n1. Get an API key from OpenAI/Gemini\n2. Add it to .env\n3. Uncomment the real AI code in aiController.js`;
    }

    res.json({
      success: true,
      data: {
        question,
        answer,
        timestamp: new Date(),
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
