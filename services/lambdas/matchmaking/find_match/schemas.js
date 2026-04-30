import { languages } from "./language";
import { countries } from "./countries";
export const MatchmakingRequestSchema = z.object({
  action: z.string().equals(["find_match"]),
  userData: z.object({
    userId: z
      .string()
      .regex(
        /^(usr|gst)_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,
        "Invalid userId format",
      ),
    nativeLanguage: z
      .string()
      .refine((val) => languages.includes(val) || val === "any"),
    targetLanguage: z
      .string()
      .refine((val) => languages.includes(val) || val === "any"),
    location: z.string().refine((val) => countries.includes(val)),
  }),
  filters: z.object({
    requiredNativeLanguage: z
      .string()
      .refine((val) => languages.includes(val) || val === "any")
      .optional(),
    requiredTargetLanguage: z
      .string()
      .refine((val) => languages.includes(val) || val === "any")
      .optional(),
    requiredLocation: z
      .string()
      .refine((val) => countries.includes(val))
      .optional(),
  }),
});
