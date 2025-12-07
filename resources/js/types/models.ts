export type Footer = {
  address_line_1: string;
  address_line_2: string;
  company: string;
  email: string;
  legal_links?: FooterLegalLink[];
  logo: string;
  phone: string;
  social_links?: FooterSocialLink[];
};

export type FooterSocialLink = {
  icon: string;
  label: string;
  url: string;
  position: number;
};

export type FooterLegalLink = {
  label: string;
  url: string;
  position: number;
};
